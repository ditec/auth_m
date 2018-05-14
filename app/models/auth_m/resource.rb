# == Schema Information
#
# Table name: auth_m_resources
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  management_id :integer          not null
#  default       :boolean          default(FALSE), not null
#  access        :string(255)      
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

module AuthM
  class Resource < ApplicationRecord
    include AuthM::ResourceConcern  
    
    # puts your code here
    
  end
end
