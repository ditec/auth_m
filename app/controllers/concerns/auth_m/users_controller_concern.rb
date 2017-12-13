require 'active_support/concern'

module AuthM::UsersControllerConcern
  extend ActiveSupport::Concern
  
  included do
    load_and_authorize_resource
  end

  def index
    @users = current_management.nil? ? AuthM::User.all : current_management.users
    @users = @users - [current_user]
  end

  def show
    @user = AuthM::User.find(params[:id])
  end

  def new
    @user = AuthM::User.new
  end

  def edit
    @user = AuthM::User.find(params[:id])
  end

  def create_user

    invitable? ? @user = AuthM::User.invite!(user_params) : @user = AuthM::User.new(user_params.merge(active: true))
    @user.management = current_management

    if @user.save
      create_policies @user if @user.has_role? :user
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def update
    @user = AuthM::User.find(params[:id])

    if @user.update(user_params)

      @user.policies.destroy_all
      create_policies @user if @user.has_role? :user

      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = AuthM::User.find(params[:id])
    @user.destroy
   
    redirect_to users_path
  end

  def impersonate
    user = AuthM::User.find(params[:id])
    impersonate_user(user)
    redirect_to main_app.root_path
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to main_app.root_path
  end

  def generate_new_password_email 
    user = AuthM::User.find(params[:id]) 
    user.send_reset_password_instructions 
    flash[:notice] = "Reset password instructions have been sent to #{user.email}." 
    render :edit
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :roles_mask, :active)
    end

    def create_policies(user)
      if params[:user][:policies].present?
        params[:user][:policies].each do |key, value|
          user.policies.create!(resource_id: key.to_i, access: value) if !(value == "none") && (user.management.has_the_resource_id? key.to_i)
        end
      end 
    end

    def invitable?
      params[:user][:invitable] == "1" 
    end
end