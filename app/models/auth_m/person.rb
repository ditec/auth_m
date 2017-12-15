module AuthM
  class Person < ApplicationRecord
    include AuthM::PersonConcern
    
    # puts your code here

  end
end
