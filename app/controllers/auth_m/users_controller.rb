module AuthM
  class UsersController < ApplicationController
    include AuthM::UsersControllerConcern

    # def index
    #   super
    # end    

    # def public
    #   super
    # end

    # def new
    #   super
    # end

    # def edit
    #   super
    # end

    # def create_user
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

    # def generate_new_password_email 
    #   super
    # end

    # private

    #   def user_params
    #     params.require(:user).permit(:email, :password, :password_confirmation, :roles_mask, :active, :policy_group_id, policy_group_attributes: [:id, :name, :management_id, :customized, policies_attributes: [:id, :resource_id, :access, :_destroy]])
    #   end

    #   def check_policies
    #     super
    #   end

    #   def invitable?
    #     super
    #   end

  end
end