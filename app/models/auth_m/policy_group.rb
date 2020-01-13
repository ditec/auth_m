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

module AuthM
  class PolicyGroup < ApplicationRecord
    include AuthM::PolicyGroupConcern

    # Your code goes here...
    
  end
end
