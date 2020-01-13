require 'active_support/concern'

module AuthM::UsersControllerConcern
  extend ActiveSupport::Concern
  
  included do
    authorize_resource 

    before_action :set_user, only: [:show, :edit, :update, :destroy, :impersonate]
    before_action :set_policy_group, only: [:show, :edit]
    before_action :check_params, only: [:create, :update]
    before_action :option_for_select, only: [:new, :edit]
  end

  def index
    @users = current_management.users
  end 

  def show
  end

  def new
    @user = current_management.users.new(roles: [:user])
  end

  def edit
  end

  def create
    invitable? ? @user = current_management.users.invite!(create_user_params, current_user) : @user = current_management.users.new(create_user_params.merge(confirmed_at: DateTime.now.to_date))
    @user.roles = [:user]

    if @user.save
      redirect_to @user
    else
      option_for_select
      render :new
    end
  end
  
  def update
    if @user.update(update_user_params)
      redirect_to @user
    else
      option_for_select
      render :edit
    end
  end

  def destroy
    @policy_group = @user.policy_group(current_branch)

    if (@policy_group && @user.policy_groups.where("NOT(id = ?)", @policy_group.id).empty?) || @user.policy_groups.empty?
      @user.destroy
      redirect_to users_path
    else
      redirect_to users_path, alert: t(".user_active")
    end
  end

  def impersonate
    impersonate_user(@user)
    redirect_to main_app.root_path
  end

  def stop_impersonating
    @user = current_user

    stop_impersonating_user
    redirect_to @user
  end

  private

    def set_user
      @user = current_management.users.find(params[:id])
    end

    def set_policy_group
      @policy_group = @user.policy_group(current_branch) if @user.present?
    end

    def create_user_params
      unless params[:user][:password].present? || params[:user][:password_confirmation].present?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      params.require(:user).permit(:username, :email, :password, :password_confirmation, :active, policy_groups_attributes: [:id, :name, :branch_id, :customized, :_destroy, policies_attributes: [:id, :branch_resource_id, :access, :_destroy]])
    end

    def update_user_params
      params.require(:user).permit(:username, :email, :active, policy_groups_attributes: [:id, :name, :branch_id, :customized, :_destroy, policies_attributes: [:id, :branch_resource_id, :access, :_destroy]])
    end

    def check_params
      if params[:policy_group_selector].present?
        if params[:policy_group_selector] == "Customize"          
          params[:user].merge!(policy_groups_attributes: {:"0" => {name: "Customize", branch_id: current_branch.id, customized: true, policies_attributes: params[:policy_group][:policies_attributes]}})
          params[:user][:policy_groups_attributes][:"0"][:policies_attributes].each do |key, value|
            params[:user][:policy_groups_attributes][:"0"][:policies_attributes][:"#{key}"].merge!(:_destroy => 1) if value[:access] == "none"
          end
        else
          policy_group = current_branch.policy_groups.where(id: params[:policy_group_selector]).first
          if policy_group
            if policy_group.customized?
              params[:user].merge!(policy_groups_attributes: {id: policy_group.id, policies_attributes: params[:policy_group][:policies_attributes]})
              params[:user][:policy_groups_attributes][:policies_attributes].each do |key, value|
                params[:user][:policy_groups_attributes][:policies_attributes][:"#{key}"].merge!(:_destroy => 1) if value[:access] == "none"
              end
            else
              params[:user].merge!(policy_groups_attributes: {id: policy_group.id})
            end
          end
        end 
      else
        policy_group = @user.policy_group(current_branch) if @user
        params[:user].merge!(policy_groups_attributes: {id: policy_group.id, :_destroy => 1}) if policy_group
      end 
    end

    def invitable?
      params[:user][:invitable] == "1" 
    end

    def option_for_select
      if @user && @user.persisted?
        @policy_group = @user.policy_group(current_branch)
      elsif @user
        @policy_group = @user.policy_groups.first 
      end
      
      if @user && @policy_group && @policy_group.customized?
        if @policy_group.persisted?
          @option_for_select = [["Customize", @policy_group.id]] + current_branch.policy_groups.allocable.collect{ |m| [m.name, m.id]}
          @selected = @policy_group.id
        else
          @option_for_select = [["Customize", "Customize"]] + current_branch.policy_groups.allocable.collect{ |m| [m.name, m.id]}
          @selected = "Customize"
        end
      else
        @option_for_select = [["Customize", "Customize"]] + current_branch.policy_groups.allocable.collect{ |m| [m.name, m.id]}
        @selected = @policy_group.id if @policy_group
      end
    end

end