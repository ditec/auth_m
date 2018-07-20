require 'active_support/concern'

module AuthM::UsersControllerConcern
  extend ActiveSupport::Concern
  
  included do
    load_and_authorize_resource :person, except: [:index, :stop_impersonating, :public]
    load_and_authorize_resource :user, through: :person, singleton: true, except: [:index, :stop_impersonating, :public]
    load_and_authorize_resource only: [:index, :stop_impersonating, :public]

    before_action :set_person, except: [:index, :stop_impersonating, :public]

    before_action :check_params_create, only: [:create_user]
    before_action :check_params_update, only: [:update]
  end

  def public 
    # @user = AuthM::User.publics
    @people = AuthM::Person.where(management_id: nil).order('last_name')
  end

  def new
    @user = @person.build_user
    @policy_group = @user.build_policy_group
  end

  def edit
    @user = @person.user
    @policy_group = @user.policy_group if @user.has_role? :user
  end

  def create_user

    invitable? ? @user = AuthM::User.invite!(user_params.merge(person_id: @person.id), current_user) : @user = @person.build_user(user_params.merge(active: true, confirmed_at: DateTime.now.to_date))

    if @user.save
      redirect_to person_path(@person)
    else
      @policy_group = @user.build_policy_group
      render 'new'
    end
  end
  
  def update
    @user = @person.user

    if @user.update(user_params)
      redirect_to person_path(@person)
    else
      @policy_group = @user.policy_group if @user.has_role? :user
      render 'edit'
    end
  end

  def destroy
    @user = @person.user
    @user.destroy
   
    redirect_to person_path(@person)
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
      params.require(:user).permit(:email, :password, :password_confirmation, :roles_mask, :active, :policy_group_id, policy_group_attributes: [:id, :name, :management_id, :customized, policies_attributes: [:id, :resource_id, :access, :_destroy]]).reject{|_, v| v.blank?}
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
          AuthM::Person.find(params[:person_id]).user.policy_group.delete if params[:person_id].present? && AuthM::Person.find(params[:person_id]).user && AuthM::Person.find(params[:person_id]).user.policy_group.customized?
          params[:user].delete(:policy_group_attributes)
          params[:user][:policy_group_id] = params[:policy_group_selector]
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