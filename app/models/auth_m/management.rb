# == Schema Information
#
# Table name: auth_m_managements
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module AuthM
  class Management < ApplicationRecord
    include AuthM::ManagementConcern

    # puts your code here
    
  end
end
