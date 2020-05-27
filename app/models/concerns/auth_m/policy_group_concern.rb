# == Schema Information
#
# Table name: auth_m_policy_groups
#
#  id         :bigint           not null, primary key
#  customized :boolean          default(FALSE)
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  branch_id  :bigint           not null
#
# Indexes
#
#  index_auth_m_policy_groups_on_branch_id  (branch_id)
#

require 'active_support/concern'

module AuthM::PolicyGroupConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :branch
    has_many :policy_groups_users, inverse_of: :policy_group
    has_many :users, through: :policy_groups_users
    has_many :policies, inverse_of: :policy_group, dependent: :destroy

    accepts_nested_attributes_for :policies, allow_destroy: true

    validates :name, presence: true, length: { maximum: 254 }
    validates :branch, presence: true
    validates :customized, inclusion: { in: [true, false] }

    before_save :capitalize_name
    before_destroy { |policy_group| policy_group.users.delete_all }

    scope :allocable, -> {where(customized: false)}
  end

  def customized? 
    self.customized
  end

  def has_the_policy? resource_id
    self.policies.where(branch_resource_id: resource_id).first
  end

  private 

    def capitalize_name
      self.name = self.name.capitalize
    end
end