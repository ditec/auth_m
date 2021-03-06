# == Schema Information
#
# Table name: auth_m_branches
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

module AuthM
  RSpec.describe Branch, type: :model do

    describe "#shoulda_matchers ->" do
      it { should have_many(:users).dependent(:destroy) }
      it { should have_many(:resources).dependent(:destroy) }
      
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name).is_at_least(2).is_at_most(254) }

      it { should validate_uniqueness_of(:name) }
    end

    describe "#validate_resources ->" do
      let(:branch){FactoryBot.create(:auth_m_branch)}
      let(:resource){FactoryBot.create(:auth_m_resource, branch_id: branch.id)}

      it "test1" do
        expect(branch.has_the_resource_name? resource.name).to be_truthy
      end

      it "test2" do
        expect(branch.has_the_resource_id? resource.id).to be_truthy
      end

      it "test3" do
        expect(branch.has_the_resource_name? "Article").to be_falsey
      end

      it "test4" do
        expect(branch.has_the_resource_id? 15).to be_falsey
      end
    end

    describe "#validate_users ->" do
      let(:branch){FactoryBot.create(:auth_m_branch)}
      let(:user){FactoryBot.create(:auth_m_user, branch_id: branch.id)}
      let(:user2){FactoryBot.create(:auth_m_user)}

      it "test1" do
        expect(branch.users).to include(user)
      end
      it "test2" do
        expect(branch.users).to_not include(user2)
      end
    end

    describe "#validate_methods ->" do 
      it "test1" do 
        branch = FactoryBot.build(:auth_m_branch, name: "dummy")
        expect { branch.save }.to change(branch, :name).from("dummy").to("Dummy")
      end
    end
    
  end
end
