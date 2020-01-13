# == Schema Information
#
# Table name: auth_m_management_resources
#
#  id            :bigint           not null, primary key
#  name          :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  management_id :bigint           not null
#
# Indexes
#
#  index_auth_m_management_resources_on_management_id  (management_id)
#

module AuthM
  class ManagementResource < ApplicationRecord
    include AuthM::ManagementResourceConcern  
    
    # Your code goes here...
    
  end
end
