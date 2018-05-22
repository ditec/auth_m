require 'active_support/concern'

module AuthM::UsersControllerConcern
  extend ActiveSupport::Concern
  
  included do
    load_and_authorize_resource :person, except: [:index, :stop_impersonating, :public]
    load_and_authorize_resource :user, through: :person, singleton: true, except: [:index, :stop_impersonating, :public]
    load_and_authorize_resource only: [:index, :stop_impersonating, :public]

    before_action :set_person, except: [:index, :stop_impersonating, :public]
  end

  def public
    @users = AuthM::User.publics
  end

  def index
    @users = current_management.users.order("email").reject{|x| x == current_user}
  end

  def show
    @user = @person.user
  end

  def new
    @user = @person.build_user
  end

  def edit
    @user = @person.user
  end

  def create_user

    invitable? ? @user = AuthM::User.invite!(user_params.merge(person_id: @person.id), current_user) : @user = @person.build_user(user_params.merge(active: true, confirmed_at: DateTime.now.to_date))

    if @user.save
      create_policies @user if @user.has_role? :user
      redirect_to @person
    else
      render 'new'
    end
  end
  
  def update
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
    @user = @person.user
    @user.destroy
   
    redirect_to @person
  end

  def impersonate
    @user = @person.user
    impersonate_user(@user)
    redirect_to main_app.root_path
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to main_app.root_path
  end

  def generate_new_password_email 
    @user = @person.user
    @user.send_reset_password_instructions 
    flash[:notice] = "Reset password instructions have been sent to #{@user.email}." 
    render :edit
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :roles_mask, :active).reject{|_, v| v.blank?}
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

    def set_person
      @person = AuthM::Person.find(params[:person_id])
    end

end