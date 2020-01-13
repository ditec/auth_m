# == Schema Information
#
# Table name: auth_m_policy_groups_users
#
#  policy_group_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_auth_m_policy_groups_users_on_policy_group_id              (policy_group_id)
#  index_auth_m_policy_groups_users_on_user_id                      (user_id)
#  index_auth_m_policy_groups_users_on_user_id_and_policy_group_id  (user_id,policy_group_id)
#

require 'active_support/concern'

module AuthM::PolicyGroupsUserConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :user
    belongs_to :policy_group

    validates :user, presence: true
    validates :policy_group, presence: true

    validate :_policy_group, on: :create
    validate :_management

    after_destroy :customized?
  end

  private 

    def _policy_group
      if self.user && self.policy_group
        self.user.policy_groups.where(branch_id: self.policy_group.branch_id).each do |a|
          self.user.policy_groups.delete(a)
          a.destroy if a.customized?
        end
      end
    end

    def _management
      errors.add(:base, "Invalid Management") unless self.user.management.id == self.policy_group.branch.management.id
    end

    def customized?
      if self.policy_group.customized?
        self.user.policy_groups.delete(self.policy_group)
        self.policy_group.destroy 
      end
    end
end