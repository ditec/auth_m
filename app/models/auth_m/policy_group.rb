# == Schema Information
#
# Table name: auth_m_policy_groups
#
#  id            :bigint(8)        not null, primary key
#  name          :string(255)      not null
#  management_id :bigint(8)
#  customized    :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

module AuthM
  class PolicyGroup < ApplicationRecord
    include AuthM::PolicyGroupConcern

    # puts your code here
    
  end
end
