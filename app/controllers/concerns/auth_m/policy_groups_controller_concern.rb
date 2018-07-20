require 'active_support/concern'

module AuthM::PolicyGroupsControllerConcern
  extend ActiveSupport::Concern
  
  included do
    load_and_authorize_resource

    before_action :set_policy_group, except: [:index, :new, :create, :load_policies]
    before_action :check_policies, only: [:create, :update]
  end

  def index
    @policy_groups = current_management.policy_groups.where(customized: false)
  end

  def show
  end

  def new
    @policy_group = current_management.policy_groups.new
  end

  def edit
  end
  
  def create
    @policy_group = current_management.policy_groups.new(policy_group_params.merge(customized: false))

    if @policy_group.save
      redirect_to policy_group_path(@policy_group)
    else
      render 'new'
    end
  end

  def update
    if @policy_group.update(policy_group_params)
      redirect_to policy_group_path(@policy_group)
    else
      render 'edit'
    end
  end

  def destroy
    @policy_group.destroy
   
    redirect_to policy_groups_path 
  end

  def load_policies 

    if params[:policy_group_selector].present? && !(params[:policy_group_selector] == "Customize")
      @policy_group = current_management.policy_groups.find(params[:policy_group_selector])
    else
      @policy_group = nil
    end 

    respond_to do |format|
      format.js
    end 
  end

  private

    def policy_group_params
      params.require(:policy_group).permit(:name, :customized, policies_attributes: [:id, :resource_id, :access, :_destroy])
    end

    def set_policy_group
      @policy_group = current_management.policy_groups.find(params[:id])
    end

    def check_policies
      if params[:policy_group][:policies_attributes].present?
        params[:policy_group][:policies_attributes].each do |key, value|
          params[:policy_group][:policies_attributes][:"#{key}"].merge!(:_destroy => 1) if value[:access] == "none"
        end
      end
    end 

end