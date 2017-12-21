require 'rails_helper'

module AuthM
  RSpec.describe Person, type: :model do

    describe "#shoulda_matchers ->" do
      it { should belong_to(:management) }
      it { should have_one(:user).dependent(:destroy) }

      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }

      it { should validate_length_of(:first_name).is_at_least(4).is_at_most(250) }
      it { should validate_length_of(:last_name).is_at_least(4).is_at_most(250) }
      it { should validate_length_of(:dni).is_at_least(6).is_at_most(20) }

      it { should validate_numericality_of(:dni).only_integer }

      it { should validate_uniqueness_of(:dni) }
    end

    describe "#validate_methods ->" do 
      it "test1" do 
        person = FactoryBot.build(:auth_m_person, first_name: "dummy")
        expect { person.save }.to change(person, :first_name).from("dummy").to("Dummy")
      end     
      it "test2" do 
        person = FactoryBot.build(:auth_m_person, last_name: "test")
        expect { person.save }.to change(person, :last_name).from("test").to("Test")
      end
    end
    
  end
end
