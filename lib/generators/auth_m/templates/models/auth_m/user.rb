module AuthM
  class User < ApplicationRecord
    include AuthM::UserConcern

    # def self.roles
    #   super
    # end

    # def default_role
    #   super
    # end

    # def role
    #   super
    # end

    # def has_the_policy? resource_id
    #   super(resource_id)
    # end
  
  end
end
