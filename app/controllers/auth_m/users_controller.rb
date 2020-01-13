module AuthM
  class UsersController < ApplicationController
    include AuthM::UsersControllerConcern
    # authorize_resource 

    # before_action :set_user, only: [:show, :edit, :update, :destroy, :impersonate]
    # before_action :set_policy_group, only: [:show, :edit]
    # before_action :check_params, only: [:create, :update]
    # before_action :option_for_select, only: [:new, :edit]

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

    # def impersonate
    #   super
    # end

    # def stop_impersonating
    #   super
    # end

    # private

    #   def set_user
    #     super
    #   end

    #   def set_policy_group
    #     super
    #   end

    #   def create_user_params
    #     super
    #   end

    #   def update_user_params
    #     super
    #   end

    #   def check_params
    #     super
    #   end

    #   def invitable?
    #     super
    #   end

    #   def option_for_select
    #     super
    #   end
  end
end