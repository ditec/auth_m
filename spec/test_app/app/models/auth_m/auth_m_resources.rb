module AuthM
  class Resource < ApplicationRecord
    include AuthM::ResourceConcern  
    
    def self.list
      return [["AuthM::User", "AuthM::User"]]
    end
    
  end
end