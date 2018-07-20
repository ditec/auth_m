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

require 'rails_helper'

module AuthM
  RSpec.describe Policy, type: :model do

    describe "#shoulda_matchers ->" do
      it { should belong_to(:resource) }
      it { should belong_to(:policy_group) }
      it {
        management = FactoryBot.create(:auth_m_management)
        policy_group = FactoryBot.create(:auth_m_policy_group, management_id: management.id)
        resource = FactoryBot.create(:auth_m_resource, management_id: management.id)
        policy = FactoryBot.create(:auth_m_policy, policy_group_id: policy_group.id, resource_id: resource.id)
        policy.should validate_inclusion_of(:access).in_array(['read', 'manage']) 
      }
    end
    
  end
end
