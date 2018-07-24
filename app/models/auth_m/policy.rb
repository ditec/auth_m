# == Schema Information
#
# Table name: auth_m_policies
#
#  id              :bigint(8)        not null, primary key
#  resource_id     :bigint(8)
#  policy_group_id :bigint(8)
#  access          :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

module AuthM
  class Policy < ApplicationRecord
    include AuthM::PolicyConcern

    # Your code goes here...
    
  end
end
