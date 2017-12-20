# == Schema Information
#
# Table name: auth_m_policies
#
#  id          :integer          not null, primary key
#  resource_id :integer
#  user_id     :integer
#  access      :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module AuthM
  class Policy < ApplicationRecord
    include AuthM::PolicyConcern

    # puts your code here
    
  end
end
