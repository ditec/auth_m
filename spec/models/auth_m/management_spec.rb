require 'rails_helper'

module AuthM
  RSpec.describe Management, type: :model do

    describe "#shoulda_matchers ->" do
      it { should have_many(:people).dependent(:destroy) }
      it { should have_many(:resources).dependent(:destroy) }
      
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name).is_at_least(4).is_at_most(250) }

      it { should validate_uniqueness_of(:name) }
    end

    describe "#validate_resources ->" do
      let(:management){FactoryBot.create(:auth_m_management)}
      let(:resource){FactoryBot.create(:auth_m_resource, management: management)}

      it "test1" do
        expect(management.has_the_resource_name? resource.name).to be_truthy
      end

      it "test2" do
        expect(management.has_the_resource_id? resource.id).to be_truthy
      end

      it "test3" do
        expect(management.has_the_resource_name? "AuthM::Users").to be_falsey
      end

      it "test4" do
        expect(management.has_the_resource_id? 15).to be_falsey
      end
    end

    describe "#validate_users ->" do
      let(:management){FactoryBot.create(:auth_m_management)}
      let(:user){FactoryBot.create(:auth_m_user, person: FactoryBot.create(:auth_m_person, management: management))}
      let(:user2){FactoryBot.create(:auth_m_user)}

      it "test1" do
        expect(management.users).to include(user)
      end
      it "test2" do
        expect(management.users).to_not include(user2)
      end
    end
    
  end
end
