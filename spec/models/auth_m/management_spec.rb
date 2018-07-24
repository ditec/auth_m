# == Schema Information
#
# Table name: auth_m_managements
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

module AuthM
  RSpec.describe Management, type: :model do

    describe "#shoulda_matchers ->" do
      it { should have_many(:users).dependent(:destroy) }
      it { should have_many(:resources).dependent(:destroy) }
      
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name).is_at_least(4).is_at_most(250) }

      it { should validate_uniqueness_of(:name) }
    end

    describe "#validate_resources ->" do
      let(:management){FactoryBot.create(:auth_m_management)}
      let(:resource){FactoryBot.create(:auth_m_resource, management_id: management.id)}

      it "test1" do
        expect(management.has_the_resource_name? resource.name).to be_truthy
      end

      it "test2" do
        expect(management.has_the_resource_id? resource.id).to be_truthy
      end

      it "test3" do
        expect(management.has_the_resource_name? "Article").to be_falsey
      end

      it "test4" do
        expect(management.has_the_resource_id? 15).to be_falsey
      end
    end

    describe "#validate_users ->" do
      let(:management){FactoryBot.create(:auth_m_management)}
      let(:user){FactoryBot.create(:auth_m_user, management_id: management.id)}
      let(:user2){FactoryBot.create(:auth_m_user)}

      it "test1" do
        expect(management.users).to include(user)
      end
      it "test2" do
        expect(management.users).to_not include(user2)
      end
    end

    describe "#validate_methods ->" do 
      it "test1" do 
        management = FactoryBot.build(:auth_m_management, name: "dummy")
        expect { management.save }.to change(management, :name).from("dummy").to("Dummy")
      end
    end
    
  end
end
