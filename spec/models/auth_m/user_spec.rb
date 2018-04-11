# == Schema Information
#
# Table name: auth_m_users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  roles_mask             :integer          default(2), not null
#  active                 :boolean          default(FALSE), not null
#  person_id              :integer
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string(255)
#  invited_by_id          :integer
#  invitations_count      :integer          default(0)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'
require "cancan/matchers"

module AuthM
  RSpec.describe User, type: :model do
    
    describe "#shoulda_matchers ->" do
      it { should have_many(:policies).dependent(:destroy) }
      it { should belong_to(:person) }

      it { should validate_presence_of(:email) }

      it{ 
        user = FactoryBot.create(:auth_m_user)
        user.build_validation 
        user.should validate_presence_of(:roles_mask) 
      }
      
      it { 
        user = FactoryBot.create(:auth_m_user)
        user.build_validation 
        user.should validate_presence_of(:person_id) 
      }
    end

    describe "#validate_roles ->" do
      let(:user){FactoryBot.create(:auth_m_user)}

      it "test1" do
        user.assign_attributes(roles: [:root])
        user.build_validation
        user.save
        expect(user.errors.full_messages).to include("User cannot save how root")
      end

      it "test2" do 
        user.assign_attributes(roles: [:admin])
        ability = AuthM::Ability.new(user)

        ability.should be_able_to(:manage, AuthM::Person.new(management_id: user.person.management_id))
      end

      it "test3" do 
        policy = FactoryBot.create(:auth_m_policy, access: "manage", user: user)
        ability = AuthM::Ability.new(user)

        ability.should be_able_to(:manage, AuthM::Person.new(management_id: user.person.management_id))
      end

      it "test4" do 
        policy = FactoryBot.create(:auth_m_policy, access: "read", user: user)
        ability = AuthM::Ability.new(user)

        ability.should be_able_to(:read, AuthM::Person.new(management_id: user.person.management_id))
      end

      it "test5" do
        user.build_validation
        user.assign_attributes(roles: [:super_admin])
        user.save

        expect(user.valid?).to be_falsey
      end

      it "test6" do 
        ability = AuthM::Ability.new(user)

        ability.should_not be_able_to(:manage, AuthM::Person.new(management_id: user.person.management_id))
      end

      it "test7" do
        expect(AuthM::User.roles).to_not include(:root)
      end

      it "test8" do
        user.assign_attributes(roles: [:root])

        expect { user.default_role }.to change(user, :roles_mask).from(4).to(2)
      end

      it "test9" do
        expect(user.role).to eq(:user)
      end
    end

    describe "#validate_methods ->" do
      let(:user){FactoryBot.create(:auth_m_user)}

      it "test1" do 
        policy = FactoryBot.create(:auth_m_policy, user: user, access: "manage")
        expect(user.has_the_policy? policy.resource.id).to be_truthy
      end

      it "test2" do 
        user2 = FactoryBot.create(:auth_m_user)
        policy = FactoryBot.create(:auth_m_policy, access: "manage", user: user2)
        expect(user.has_the_policy? policy.resource.id).to be_falsey
      end

      it "test3" do 
        expect(user.management).to eq(user.person.management)
      end
    end

    describe "#validate_scopes ->" do
      let(:user1){ FactoryBot.create(:auth_m_user, roles: [:admin]) }
      let(:user2){ FactoryBot.create(:auth_m_user, roles: [:user])  }       
      let(:user3){ FactoryBot.create(:auth_m_user, roles: [:admin]) }
      let(:user4){ FactoryBot.create(:auth_m_user, roles: [:user])  }

      it "test1" do 
        expect(AuthM::User.users).to contain_exactly(user2, user4)
      end

      it "test2" do 
        expect(AuthM::User.admins).to contain_exactly(user1, user3)
      end
    end
  end
end
