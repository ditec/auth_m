require 'rails_helper'

module AuthM
  RSpec.describe Policy, type: :model do

    describe "#shoulda_matchers ->" do
      it { should belong_to(:resource) }
      it { should belong_to(:user) }
      it { should validate_inclusion_of(:access).in_array(['read', 'manage']) }
    end
    
  end
end
