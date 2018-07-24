require 'active_support/concern'

module AuthM::UsersControllerConcern
  extend ActiveSupport::Concern
  
  included do
    load_and_authorize_resource 

    before_action :set_user, except: [:index, :public, :new, :create_user, :stop_impersonating]

    before_action :check_params_create, only: [:create_user]
    before_action :check_params_update, only: [:update]
  end

  def index
    @users = current_management.users
  end 

  def public 
    @users = AuthM::User.publics
  end

  def new
    @user = AuthM::User.new
    @policy_group = @user.build_policy_group
  end

  def edit
    @policy_group = @user.policy_group if @user.has_role? :user
  end

  def create_user

    invitable? ? @user = AuthM::User.invite!(user_params.merge(management_id: current_management.id), current_user) : @user = current_management.users.new(user_params.merge(active: true, confirmed_at: DateTime.now.to_date))

    if @user.save
      redirect_to user_path(@user)
    else
      @policy_group = @user.build_policy_group
      render 'new'
    end
  end
  
  def update

    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      @policy_group = @user.policy_group if @user.has_role? :user
      render 'edit'
    end
  end

  def destroy
    @user.destroy
   
    redirect_to users_path
  end

  def impersonate
    impersonate_user(@user)
    redirect_to main_app.root_path
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to main_app.root_path
  end

  def generate_new_password_email 
    @user.send_reset_password_instructions 
    flash[:notice] = "Reset password instructions have been sent to #{@user.email}." 
    render :edit
  end

  private

    def user_params
      unless params[:user][:password].present? || params[:user][:password_confirmation].present?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      params.require(:user).permit(:email, :password, :password_confirmation, :roles_mask, :active, :policy_group_id, policy_group_attributes: [:id, :name, :management_id, :customized, policies_attributes: [:id, :resource_id, :access, :_destroy]])

    end

    def check_params_create
      if params[:policy_group_selector].present? 
        if params[:policy_group_selector] == "Customize"          
          params[:user][:policy_group_attributes].merge!(name: "Customize", management_id: current_management.id, customized: true)
          params[:user][:policy_group_attributes][:policies_attributes].each do |key, value|
            params[:user][:policy_group_attributes][:policies_attributes][:"#{key}"].merge!(:_destroy => 1) if value[:access] == "none"
          end
        else
          params[:user].delete(:policy_group_attributes)
          params[:user][:policy_group_id] = params[:policy_group_selector]
        end 
      else
        params[:user].delete(:policy_group_attributes)
      end 
    end

    def check_params_update
      if params[:policy_group_selector].present? 
        if params[:policy_group_selector] == "Customize"
          if params[:user][:policy_group_attributes][:id].present? && !AuthM::PolicyGroup.find(params[:user][:policy_group_attributes][:id]).customized?
            params[:user][:policy_group_attributes].delete(:id)
            params[:user][:policy_group_attributes].merge!(name: "Customize", management_id: current_management.id, customized: true)

            params[:user][:policy_group_attributes][:policies_attributes].each do |key, value|
              params[:user][:policy_group_attributes][:policies_attributes][:"#{key}"].delete(:id)
              params[:user][:policy_group_attributes][:policies_attributes][:"#{key}"].merge!(:_destroy => 1) if value[:access] == "none"
            end
          else           
            params[:user][:policy_group_attributes][:policies_attributes].each do |key, value|
              params[:user][:policy_group_attributes][:policies_attributes][:"#{key}"].merge!(:_destroy => 1) if value[:access] == "none"
            end
          end
        else
          user = AuthM::User.find(params[:id])

          user.policy_group.delete if !user.nil? && user.policy_group.customized?
          params[:user].delete(:policy_group_attributes)
          params[:user][:policy_group_id] = params[:policy_group_selector]
        end 
      else
        params[:user].delete(:policy_group_attributes)
      end 
    end 

    def invitable?
      params[:user][:invitable] == "1" 
    end

    def set_user
      @user = AuthM::User.find(params[:id])
    end

end