module AuthM
  class Ability
    include CanCan::Ability

    def initialize(user)
      # Define abilities for the passed in user here. For example:
      #
      user ||= AuthM::User.new # guest user (not logged in)
      #   if user.admin?
      #     can :manage, :all
      #   else
      #     can :read, :all
      #   end
      #
      # The first argument to `can` is the action you are giving the user
      # permission to do.
      # If you pass :manage it will apply to every action. Other common actions
      # here are :read, :create, :update and :destroy.
      #
      # The second argument is the resource the user can perform the action on.
      # If you pass :all it will apply to every resource. Otherwise pass a Ruby
      # class of the resource.
      #
      # The third argument is an optional hash of conditions to further filter the
      # objects.
      # For example, here the user can only update published articles.
      #
      #   can :update, Article, :published => true
      #
      # See the wiki for details:
      # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

      if user.has_role? :root
        can :manage, :all
      end

      if user.has_role? :admin
        can :manage, AuthM::User, management_id: user.management_id
        user.management.resources.each do |resource|
          if resource.name.constantize.reflect_on_association(:management)
            can :manage, resource.name.constantize, management_id: user.management_id
          else
            can :manage, resource.name.constantize
          end
        end
      end

      if user.has_role? :user
        user.policies.each do |policy|
          if policy.resource.name.constantize.reflect_on_association(:management)
            can :"#{policy.access}", policy.resource.name.constantize, management_id: user.management_id 
          else
            can :"#{policy.access}", policy.resource.name.constantize
          end
        end
        
        can :stop_impersonating, AuthM::User
      end
    end
  end
end

