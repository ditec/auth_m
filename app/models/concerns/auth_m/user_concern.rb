# == Schema Information
#
# Table name: auth_m_users
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(TRUE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  expired_at             :datetime
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string(255)
#  invitations_count      :integer          default(0)
#  invited_by_type        :string(255)
#  last_activity_at       :datetime
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  roles_mask             :integer          not null
#  sign_in_count          :integer          default(0), not null
#  username               :string(255)      not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#  management_id          :bigint
#  unique_session_id      :string(255)
#
# Indexes
#
#  index_auth_m_users_on_confirmation_token                 (confirmation_token)
#  index_auth_m_users_on_email                              (email) UNIQUE
#  index_auth_m_users_on_expired_at                         (expired_at)
#  index_auth_m_users_on_invitation_token                   (invitation_token) UNIQUE
#  index_auth_m_users_on_invitations_count                  (invitations_count)
#  index_auth_m_users_on_invited_by_id                      (invited_by_id)
#  index_auth_m_users_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_auth_m_users_on_last_activity_at                   (last_activity_at)
#  index_auth_m_users_on_management_id                      (management_id)
#  index_auth_m_users_on_reset_password_token               (reset_password_token) UNIQUE
#

require 'active_support/concern'
require 'role_model'

module AuthM::UserConcern
  extend ActiveSupport::Concern
  
  included do
    include RoleModel

    belongs_to :management, optional: true
    has_many :linked_accounts, inverse_of: :user, dependent: :destroy
    has_many :invitations, :class_name => self.to_s, :as => :invited_by
    
    has_many :policy_groups_users, inverse_of: :user
    has_many :policy_groups, through: :policy_groups_users

    accepts_nested_attributes_for :policy_groups, allow_destroy: true, reject_if: :_public?

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable, :confirmable, :invitable, 
           :recoverable, :rememberable, :trackable, :omniauthable,
           :secure_validatable, :session_limitable, :expirable, 
           :omniauth_providers => [:facebook, :google_oauth2, :twitter]

    attr_writer :login

    roles_attribute :roles_mask

    roles :public, :user, :root

    scope :users, -> { where(roles_mask: AuthM::User.mask_for(:user)) }
    scope :publics, -> { where(roles_mask: AuthM::User.mask_for(:public)) }
    scope :active, -> { where(:active => true) }

    validates :username, presence: :true, uniqueness: { case_sensitive: false }
    validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
    validate :validate_username

    validate :set_default_role, on: :create
    validates_presence_of :roles_mask
    validate :_root?

    before_destroy { |user| user.policy_groups.destroy_all }

    def self.from_omniauth(auth)
      linked_account = AuthM::LinkedAccount.where(uid: auth.uid, provider: auth.provider).first
      return linked_account.user unless linked_account.nil?
    end

    def active_for_authentication?
      super && self.active
    end

    def login
      @login || self.username || self.email
    end

    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      elsif conditions.has_key?(:username) || conditions.has_key?(:email)
        where(conditions.to_hash).first
      end
    end

    def login_changed? 
      false 
    end
  end

  def policy_groups_attributes=(attributes)
    if attributes['id'].present?
      policy_group = AuthM::PolicyGroup.where(id: attributes['id']).first

      self.policy_groups.push(policy_group) if policy_group && !policy_group.customized?
    end
    super
  end

  def policy_group branch
    self.policy_groups.where(branch_id: branch.id).first
  end

  def branches(management)
    if management
      if self.has_role? :root 
        management.branches
      else
        self.policy_groups.includes(:branch).where(auth_m_branches: {management_id: management.id}).collect(&:branch)
      end
    end
  end

  def account_linked? provider 
    self.linked_accounts.where(provider: provider).exists?
  end

  def link_account_from_omniauth(auth)
    self.linked_accounts.new(uid: auth.uid, provider: auth.provider)
    return self.save
  end

  def default_role
    self.roles = [:public]
  end

  def role
    self.role_symbols.first
  end

  def has_the_policy? resource_id
    self.policies.find_by(resource_id: resource_id)
  end

  private
    
    def set_default_role
      self.roles = [:public] if self.roles.empty?
    end

    def _root?
      errors.add(:base, :invalid_role) if self.has_role? :root
    end

    def _public?
      self.has_role? :public
    end

    def validate_username
      if AuthM::User.where(email: username).exists?
        errors.add(:username, :invalid)
      end
    end
end