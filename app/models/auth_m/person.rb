# == Schema Information
#
# Table name: auth_m_people
#
#  id            :integer          not null, primary key
#  first_name    :string(255)      default(""), not null
#  last_name     :string(255)      default(""), not null
#  dni           :string(255)
#  management_id :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

module AuthM
  class Person < ApplicationRecord
    include AuthM::PersonConcern
    
    # puts your code here

  end
end
