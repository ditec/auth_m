require 'active_support/concern'

module AuthM::UsersControllerConcern
  extend ActiveSupport::Concern
  
  included do
    load_and_authorize_resource :person, except: [:index, :stop_impersonating, :public]
    load_and_authorize_resource :user, through: :person, singleton: true, except: [:index, :stop_impersonating, :public]
    load_and_authorize_resource only: [:index, :stop_impersonating, :public]

    before_action :set_person, except: [:index, :stop_impersonating, :public]
    before_action :check_policies, only: [:create_user, :update]
  end

  def public 
    # @user = AuthM::User.publics
    @people = AuthM::Person.where(management_id: nil).order('last_name')
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
      redirect_to @person
    else
      render 'new'
    end
  end
  
  def update
    @user = @person.user

    if @user.update(user_params)
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
      params.require(:user).permit(:email, :password, :password_confirmation, :roles_mask, :active, policies_attributes: [:id, :resource_id, :access, :_destroy]).reject{|_, v| v.blank?}
    end

    def check_policies
      if params[:user][:policies_attributes].present?
        params[:user][:policies_attributes].each do |key, value|
          params[:user][:policies_attributes][:"#{key}"].merge!(:_destroy => 1) if value[:access] == "none"
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