# == Schema Information
#
# Table name: auth_m_people
#
#  id            :bigint(8)        not null, primary key
#  first_name    :string(255)      default(""), not null
#  last_name     :string(255)      default(""), not null
#  dni           :string(255)
#  management_id :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

module AuthM
  class Person < ApplicationRecord
    include AuthM::PersonConcern
    
    # puts your code here

  end
end
