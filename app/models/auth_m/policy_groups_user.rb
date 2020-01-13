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

module AuthM
  class PolicyGroupsUser < ApplicationRecord
    include AuthM::PolicyGroupsUserConcern

    # Your code goes here...
    
  end
end
