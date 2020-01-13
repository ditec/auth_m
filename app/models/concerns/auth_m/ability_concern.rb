require 'active_support/concern'

module AuthM::AbilityConcern
  extend ActiveSupport::Concern
  
  included do
    include CanCan::Ability
  end

  def initialize(user, branch)
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

    if user.has_role? :user
      if branch
        policy_group = user.policy_group(branch)

        if policy_group
          policy_group.policies.each do |policy|

            model = build_model(policy.resource.name)
            controller = build_controller(policy.resource.name) unless model

            if model 
              if model.reflect_on_association(:branch)
                can :"#{policy.access}", model, branch_id: branch.id
              else
                can :"#{policy.access}", model
              end
            elsif controller
              can :"#{policy.access}", :"#{controller}"
            end
          end
          
          can :change, AuthM::Branch if user.policy_groups.length > 1
        end
      end
      
      can :unlink, AuthM::LinkedAccount, user_id: user.id
      can :stop_impersonating, AuthM::User
    end

    if user.has_role? :public
      can :unlink, AuthM::LinkedAccount, user_id: user.id
    end
  end

  private

    def build_model model
      if model.include?("auth_m_") 
        model_name = model.split("auth_m_")
        model = "authM::#{model_name.last.camelcase}" 
      end

      model.camelcase.singularize.constantize rescue nil
    end

    def build_controller controller
      controller.singularize
    end
end