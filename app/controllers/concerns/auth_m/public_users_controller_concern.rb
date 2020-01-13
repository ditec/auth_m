require 'active_support/concern'

module AuthM::PublicUsersControllerConcern
  extend ActiveSupport::Concern
  
  included do
    authorize_resource class: "AuthM::User"

    before_action :public_users_disabled if AuthM::Engine.public_users == false
    before_action :set_public_user, only: [:show, :edit, :update, :destroy]
  end

  def index
    @users = AuthM::User.publics
  end 

  def show
  end

  def edit
  end

  def update
    if @user.update(public_user_params)
      redirect_to public_user_path(@user)
    else
      option_for_select
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to public_users_path
  end

  private

    def set_public_user
      @user = AuthM::User.publics.find(params[:id])
    end

    def public_user_params
      params.require(:user).permit(:username, :email, :active)
    end

    def public_users_disabled
      redirect_to main_app.root_path, alert: t("auth_m.public_users.res_disabled") and return
    end
end