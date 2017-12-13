require 'active_support/concern'

module AuthM::UserConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :management, optional: true

    has_many :policies, dependent: :destroy

    validate :is_not_root?, :on => [ :create, :update ]

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :invitable, :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable

    scope :users, -> { where(roles_mask: User.mask_for(:user)) }
    scope :admins, -> { where(roles_mask: User.mask_for(:admin)) }

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
  end

  def is_not_root?
    errors.add(:user, 'cannot save how root') if self.has_role? :root
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

end