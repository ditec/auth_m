module AuthM
  class PublicUsersController < ApplicationController
    include AuthM::PublicUsersControllerConcern
    # authorize_resource class: "AuthM::User"

    # before_action :public_users_disabled if AuthM::Engine.public_users == false
    # before_action :set_public_user, only: [:show, :edit, :update, :destroy]

    # def index
    #   super
    # end 

    # def show
    #   super
    # end

    # def edit
    #   super
    # end

    # def update
    #   super
    # end

    # def destroy
    #   super
    # end

    # private

    #   def set_public_user
    #     super
    #   end

    #   def public_user_params
    #     super
    #   end

    #   def public_users_disabled
    #     super
    #   end
  end
end