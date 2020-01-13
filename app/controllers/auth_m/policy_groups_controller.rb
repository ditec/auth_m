module AuthM
  class PolicyGroupsController < ApplicationController
    include AuthM::PolicyGroupsControllerConcern
    # authorize_resource

    # before_action :set_policy_group, only: [:show, :edit, :update, :destroy]
    # before_action :check_policies, only: [:create, :update]

    # def index
    #   super
    # end

    # def show
    #   super
    # end

    # def new
    #   super
    # end

    # def edit
    #   super
    # end
    
    # def create
    #   super
    # end

    # def update
    #   super
    # end

    # def destroy
    #   super
    # end

    # def load_policies
    #   super
    # end

    # private

    #   def policy_group_params
    #     super
    #   end

    #   def set_policy_group
    #     super
    #   end

    #   def check_policies
    #     super
    #   end 
  end
end
