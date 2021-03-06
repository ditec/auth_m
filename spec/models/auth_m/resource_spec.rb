# == Schema Information
#
# Table name: auth_m_resources
#
#  id            :bigint(8)        not null, primary key
#  name          :string(255)      not null
#  branch_id :bigint(8)        not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

module AuthM
  RSpec.describe Resource, type: :model do
    
    describe "#shoulda_matchers ->" do
      it { should belong_to(:branch) }
      it { should have_many(:policies).dependent(:destroy) }
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name).is_at_least(2).is_at_most(254) }
      it { should allow_value("Articles").for(:name) }
      it { should_not allow_value("articles").for(:name) }
      it { should_not allow_value("_rticles").for(:name) }
      it { should_not allow_value("9rticles").for(:name) }
      it { should validate_presence_of(:branch) }
    end

    describe "#validate_methods ->" do    

      it "test1" do 
        expect(AuthM::Resource.list).to include(["AuthM::User", "AuthM::User"])
      end      

      it "test2" do 
        expect(AuthM::Resource.list).to_not include(["Articles", "Articles"])
      end

      it "test3" do 
        expect(AuthM::Resource.exists? "AuthM::User").to be_truthy
      end
      it "test4" do 
        expect(AuthM::Resource.exists? "Articles").to be_falsey
      end

      it "test5" do
        resource = FactoryBot.build(:auth_m_resource, name: "Dummy")
        resource.save
        expect(resource.errors.full_messages).to include("Invalid resource")
      end
    end

  end
end
