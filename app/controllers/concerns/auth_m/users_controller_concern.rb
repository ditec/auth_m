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

    if @user.save
      create_policies @user if @user.has_role? :user
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def create
    # render plain: params[:user].inspect
    @user = AuthM::User.new(user_params)
 
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    @user = AuthM::User.find(params[:id])

    @user.invite!(@user) if invitable?

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

  private

    def user_params
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      parameters = params.require(:user).permit(:email, :password, :password_confirmation, :management_id, :roles_mask, :active)
      parameters[:management_id] = current_management.id

      parameters[:active] = false if invitable?

      parameters

    end

    def policies_params
      params.require(:user).permit(policies:{}) 
    end

    def create_policies(user)
      if params[:user][:policies].present?
        policies_params[:policies].each do |key, value|
          user.policies.create!(resource_id: key.to_i, access: value) if !(value == "none") && (user.management.has_the_resource_id? key.to_i)
        end
      end 
    end

    def invitable?
      params[:user][:invitable] == "1" 
    end
end