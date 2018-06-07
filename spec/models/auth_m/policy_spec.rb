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

require 'rails_helper'

module AuthM
  RSpec.describe Policy, type: :model do

    describe "#shoulda_matchers ->" do
      it { should belong_to(:resource) }
      it { should belong_to(:user) }
      it {
        user = FactoryBot.create(:auth_m_user)
        resource = FactoryBot.create(:auth_m_resource, management_id: user.management.id)
        policy = FactoryBot.create(:auth_m_policy, user_id: user.id, resource_id: resource.id)
        policy.should validate_inclusion_of(:access).in_array(['read', 'manage']) 
      }
    end
    
  end
end
