module AuthM
  class Resource < ApplicationRecord
    include AuthM::ResourceConcern  
  end
end
