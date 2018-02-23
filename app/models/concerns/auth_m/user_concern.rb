# == Schema Information
#
# Table name: auth_m_users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  roles_mask             :integer          default(2), not null
#  active                 :boolean          default(FALSE), not null
#  person_id              :integer
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string(255)
#  invited_by_id          :integer
#  invitations_count      :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'active_support/concern'

module AuthM::UserConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :person, optional: true

    has_many :policies, dependent: :destroy

    has_many :linked_accounts, dependent: :destroy

    delegate :can?, :cannot?, :to => :ability

    validates_presence_of [:roles_mask, :active, :person_id], if: Proc.new {|user| @validate == true}

    validate :is_not_root?, :on => [ :create, :update ], if: Proc.new {|user| @validate == true}
    
    validates :roles_mask, exclusion: { in: [0] }, if: Proc.new {|user| @validate == true} 

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :invitable, :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter]

    scope :users, -> { where(roles_mask: AuthM::User.mask_for(:user)) }
    scope :admins, -> { where(roles_mask: AuthM::User.mask_for(:admin)) }

    include RoleModel

    # if you want to use a different integer attribute to store the
    # roles in, set it with roles_attribute :my_roles_attribute,
    # :roles_mask is the default name
    roles_attribute :roles_mask

    # declare the valid roles -- do not change the order if you add more
    # roles later, always append them at the end!
    #roles :admin, :user, :banned, :root

    roles :admin, :user, :root

    def self.roles
      self.valid_roles - [:root]
    end

    def self.from_omniauth(auth)
      linked_account = AuthM::LinkedAccount.where(uid: auth.uid, provider: auth.provider).first
      return linked_account.user unless linked_account.nil?
    end

  end

  def account_linked? provider 
    self.linked_accounts.where(provider: provider).exists?
  end

  def link_account_from_omniauth(auth)
    self.linked_accounts.new(uid: auth.uid, provider: auth.provider)
    return self.save
  end

  def ability
    @ability ||= AuthM::Ability.new(self)
  end

  def build_validation
    @validate = true
  end

  def default_role
    self.roles = [:user]
  end

  def role
    self.role_symbols.first
  end

  def has_the_policy? resource_id
    self.policies.find_by(resource_id: resource_id)
  end

  def management
    self.person.management unless self.person.nil?
  end

  private 
  
    def is_not_root?
      errors.add(:user, 'cannot save how root') if self.has_role? :root
    end

end