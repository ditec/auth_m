# == Schema Information
#
# Table name: auth_m_branch_resources
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  branch_id              :bigint           not null
#  management_resource_id :bigint           not null
#
# Indexes
#
#  index_auth_m_branch_resources_on_branch_id               (branch_id)
#  index_auth_m_branch_resources_on_management_resource_id  (management_resource_id)
#

module AuthM
  class BranchResource < ApplicationRecord
    include AuthM::BranchResourceConcern  
    
    # Your code goes here...
    
  end
end
