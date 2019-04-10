require 'active_support/concern'

module AuthM::AbilityConcern
  extend ActiveSupport::Concern
  
  included do
    include CanCan::Ability
  end

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
      can :unlink, AuthM::LinkedAccount, user_id: user.id
      can :manage, AuthM::User, management_id: user.management.id
      can :manage, AuthM::PolicyGroup, management_id: user.management.id
      cannot :public, AuthM::User

      user.management.resources.each do |resource|
        model = resource.name.singularize.constantize 

        if model.reflect_on_association(:management)
          can :manage, model, management_id: user.management.id
        else
          can :manage, model
        end
      end
    end

    if user.has_role? :user
      user.policy_group.policies.each do |policy|  
        model = policy.resource.name.singularize.constantize 

        if model.reflect_on_association(:management)
          can :"#{policy.access}", model, management_id: user.management.id
        else
          can :"#{policy.access}", model
        end
      end
      
      can :unlink, AuthM::LinkedAccount, user_id: user.id
      can :stop_impersonating, AuthM::User
    end

    if user.has_role? :public
      can :stop_impersonating, AuthM::User
      can :unlink, AuthM::LinkedAccount, user_id: user.id
    end

  end
end