# == Schema Information
#
# Table name: auth_m_branches
#
#  id            :bigint           not null, primary key
#  name          :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  management_id :bigint
#
# Indexes
#
#  index_auth_m_branches_on_management_id  (management_id)
#

module AuthM
  class Branch < ApplicationRecord
    include AuthM::BranchConcern

    # Your code goes here...
    
  end
end
