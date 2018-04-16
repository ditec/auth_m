module AuthM
  class Ability
    include AuthM::AbilityConcern
    
    # def initialize(user)
    #   user ||= AuthM::User.new
    #   super(user)

    #   if user.has_role? :root
    #   end

    #   if user.has_role? :admin
    #   end
      
    #   if user.has_role? :user
    #   end
    # end

  end
end
