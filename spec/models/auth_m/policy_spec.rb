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
      it { should validate_presence_of(:resource) }
      it { should validate_presence_of(:policy_group) }
      it {
        branch = FactoryBot.create(:auth_m_branch)
        policy_group = FactoryBot.create(:auth_m_policy_group, branch_id: branch.id)
        resource = FactoryBot.create(:auth_m_resource, branch_id: branch.id)
        policy = FactoryBot.create(:auth_m_policy, policy_group_id: policy_group.id, resource_id: resource.id)
        policy.should validate_inclusion_of(:access).in_array(['read', 'manage']) 
      }
    end
    
  end
end
