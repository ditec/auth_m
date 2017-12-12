module AuthM
  class Policy < ApplicationRecord
    include AuthM::PolicyConcern
  end
end
