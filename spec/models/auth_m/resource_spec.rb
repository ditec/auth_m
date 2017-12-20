require 'rails_helper'

module AuthM
  RSpec.describe Resource, type: :model do
    
    describe "#shoulda_matchers ->" do
      it { should belong_to(:management) }
      it { should have_many(:policies).dependent(:destroy) }

      it { should validate_presence_of(:name) }

      it { should validate_length_of(:name).is_at_least(2).is_at_most(250) }

      it { should allow_value("Articles").for(:name) }
      it { should_not allow_value("articles").for(:name) }
      it { should_not allow_value("_rticles").for(:name) }
      it { should_not allow_value("9rticles").for(:name) }
    end

    describe "#validate_methods ->" do
      it "test1" do 
        expect(AuthM::Resource.list).to include(["AuthM::Person", "AuthM::Person"])
      end      

      it "test2" do 
        expect(AuthM::Resource.list).to_not include(["AuthM::Articles", "AuthM::Articles"])
      end

      it "test3" do 
        expect(AuthM::Resource.exists? "AuthM::Person").to be_truthy
      end
      it "test4" do 
        expect(AuthM::Resource.exists? "AuthM::Articles").to be_falsey
      end
    end

  end
end
