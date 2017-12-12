module AuthM
  class Management < ApplicationRecord
    include AuthM::ManagementConcern

    # def has_the_resource_name? resource_name
    #   super(resource_name)
    # end

    # def has_the_resource_id? resource_id
    #   super(resource_id)
    # end
    
  end
end
