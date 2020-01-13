require 'active_support/concern'

module AuthM::PolicyGroupsControllerConcern
  extend ActiveSupport::Concern
  
  included do
    authorize_resource

    before_action :set_policy_group, only: [:show, :edit, :update, :destroy]
    before_action :check_policies, only: [:create, :update]
  end

  def index
    @policy_groups = current_branch.policy_groups.where(customized: false)
  end

  def show
  end

  def new
    @policy_group = current_branch.policy_groups.new
  end

  def edit
  end
  
  def create
    @policy_group = current_branch.policy_groups.new(policy_group_params)

    if @policy_group.save
      redirect_to policy_group_path(@policy_group)
    else
      render :new
    end
  end

  def update
    if @policy_group.update(policy_group_params)
      redirect_to policy_group_path(@policy_group)
    else
      render :edit
    end
  end

  def destroy
    @policy_group.destroy
   
    redirect_to policy_groups_path 
  end

  def load_policies
    if params[:policy_selected].present?
      if params[:policy_selected] == "Customize"
        @policy_group = current_branch.policy_groups.new(customized: true)
      else
        @policy_group = current_branch.policy_groups.where(id: params[:policy_selected]).first
      end
    end

    respond_to do |format|
      format.js{render template: 'auth_m/policy_groups/policies/load', locals: {policy_group: @policy_group}}
    end 
  end

  private

    def policy_group_params
      params.require(:policy_group).permit(:name, :customized, policies_attributes: [:id, :branch_resource_id, :access, :_destroy])
    end

    def set_policy_group
      @policy_group = current_branch.policy_groups.find(params[:id])
    end

    def check_policies
      if params[:policy_group][:policies_attributes].present?
        params[:policy_group][:policies_attributes].each do |key, value|
          params[:policy_group][:policies_attributes][:"#{key}"].merge!(:_destroy => 1) if value[:access] == "none"
        end
      end
    end 

end