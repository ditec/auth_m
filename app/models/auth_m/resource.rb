# == Schema Information
#
# Table name: auth_m_resources
#
#  id            :bigint(8)        not null, primary key
#  name          :string(255)      not null
#  management_id :bigint(8)        not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

module AuthM
  class Resource < ApplicationRecord
    include AuthM::ResourceConcern  
    
    # Your code goes here...
    
  end
end
