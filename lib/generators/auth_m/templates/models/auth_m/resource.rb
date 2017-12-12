module AuthM
  class Resource < ApplicationRecord
    include AuthM::ResourceConcern

    # def self.list
    #   super
    # end

    # def self.exists? resource
    #   super(resource)
    # end
    
  end
end
