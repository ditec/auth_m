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
    @person = AuthM::Person.find(params[:person_id])
    @user = @person.user
  end

  def new
    @person = AuthM::Person.find(params[:person_id])
    @user = @person.build_user
  end

  def edit
    @person = AuthM::Person.find(params[:person_id])
    @user = @person.user
  end

  def create_user

    @person = AuthM::Person.find(params[:person_id])

    invitable? ? @user = AuthM::User.invite!(user_params.merge(person_id: @person.id)) : @user = @person.build_user(user_params.merge(active: true))

    if @user.save
      create_policies @user if @user.has_role? :user
      redirect_to @person
    else
      render 'new'
    end
  end
  
  def update
    @person = AuthM::Person.find(params[:person_id])
    @user = @person.user

    if @user.update(user_params)

      @user.policies.destroy_all
      create_policies @user if @user.has_role? :user

      redirect_to @person
    else
      render 'edit'
    end
  end

  def destroy
    @person = AuthM::Person.find(params[:person_id])
    @user = @person.user.destroy
   
    redirect_to @person
  end

  def impersonate
    @person = AuthM::Person.find(params[:person_id])
    @user = @person.user
    impersonate_user(@user)
    redirect_to main_app.root_path
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to main_app.root_path
  end

  def generate_new_password_email 
    @person = AuthM::Person.find(params[:person_id])
    @user = @person.user
    @user.send_reset_password_instructions 
    flash[:notice] = "Reset password instructions have been sent to #{@user.email}." 
    render :edit
  end

  private

    def user_params
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
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