module AuthM
  class Ability
    include AuthM::AbilityConcern
    
    # def initialize(user)
    #   super(user)
    #
    #   if user && (user.has_role? :root)
    #   end
    #
    #   if user && (user.has_role? :admin)
    #   end
    # 
    #   if user && (user.has_role? :user)
    #   end    
    #
    #   if user && (user.has_role? :public)
    #   end
    # end

  end
end
