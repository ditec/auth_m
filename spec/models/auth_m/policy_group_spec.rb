# == Schema Information
#
# Table name: auth_m_policy_groups
#
#  id            :bigint(8)        not null, primary key
#  name          :string(255)      not null
#  branch_id :bigint(8)
#  customized    :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

module AuthM
  RSpec.describe PolicyGroup, type: :model do
    describe "#shoulda_matchers ->" do
      it { should belong_to(:branch) }
      it { should have_many(:policies).dependent(:destroy) }
      it { should have_many(:users) }
      it { should accept_nested_attributes_for(:policies) }
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name).is_at_least(2).is_at_most(254) }
      it { should validate_presence_of(:branch) }
      it { should allow_value(true).for(:customized) }
      it { should allow_value(false).for(:customized) }
    end

    describe "#validate_scopes ->" do
      let(:policy_group){ FactoryBot.create(:auth_m_policy_group, customized: false) }
      let(:policy_group2){ FactoryBot.create(:auth_m_policy_group, customized: true) }

      it "test1" do 
        expect(AuthM::PolicyGroup.allocable).to contain_exactly(policy_group)
      end
    end

    describe "#validate_methods ->" do
      let(:branch){FactoryBot.create(:auth_m_branch)}

      it "test1" do 
        policy_group = FactoryBot.create(:auth_m_policy_group, name: "dummy", branch_id: branch.id, customized: false)
        expect(policy_group.name).to eq("Dummy")
      end
      
    end
  end
end
