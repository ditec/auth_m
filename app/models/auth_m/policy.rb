# == Schema Information
#
# Table name: auth_m_policies
#
#  id                 :bigint           not null, primary key
#  access             :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  branch_resource_id :bigint
#  policy_group_id    :bigint
#
# Indexes
#
#  index_auth_m_policies_on_branch_resource_id  (branch_resource_id)
#  index_auth_m_policies_on_policy_group_id     (policy_group_id)
#

module AuthM
  class Policy < ApplicationRecord
    include AuthM::PolicyConcern

    # Your code goes here...
    
  end
end
