require 'rails_helper'
require "cancan/matchers"

module AuthM
  RSpec.describe User, type: :model do

    describe "#role_validate" do

      it "should not be saved as root" do
        user = FactoryBot.build(:auth_m_user, roles: [:root])
        user.save
        expect(user.errors.full_messages).to include("User cannot save how root")
      end

      it "admin should has permissions for manage" do 
        user = FactoryBot.build(:auth_m_user, roles: [:admin])
        ability = AuthM::Ability.new(user)

        ability.should be_able_to(:manage, AuthM::Person.new(management_id: user.person.management_id))
      end

      it "user should has permissions for manage" do 
        user = FactoryBot.build(:auth_m_user, roles: [:user])
        policy = FactoryBot.build(:auth_m_policy_person, access: "manage")
        policy.user = user
        policy.save
        ability = AuthM::Ability.new(user)

        ability.should be_able_to(:manage, AuthM::Person.new(management_id: user.person.management_id))
      end

      it "user should has permissions for read" do 
        user = FactoryBot.build(:auth_m_user, roles: [:user])
        policy = FactoryBot.build(:auth_m_policy_person, access: "read")
        policy.user = user
        policy.save
        ability = AuthM::Ability.new(user)

        ability.should be_able_to(:read, AuthM::Person.new(management_id: user.person.management_id))
      end

      it "user should not has permissions" do 
        user = FactoryBot.build(:auth_m_user, roles: [:user])
        ability = AuthM::Ability.new(user)

        ability.should_not be_able_to(:manage, AuthM::Person.new(management_id: user.person.management_id))
      end

    end

  end
end
