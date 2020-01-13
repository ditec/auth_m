require 'active_support/concern'

module AuthM::BranchesControllerConcern
  extend ActiveSupport::Concern
  
  included do
    authorize_resource

    before_action :set_branch, only: [:show, :edit, :update, :destroy]
    before_action :check_resources, only: [:create, :update]
  end

  def show
  end

  def new
    @branch = current_management.branches.new
  end

  def edit
  end
  
  def create
    @branch = current_management.branches.new(branch_params)
 
    if @branch.save
      set_current_branch(@branch.id)
      redirect_to @branch
    else
      render :new
    end
  end

  def update
    if @branch.update(branch_params)
      redirect_to @branch
    else
      render :edit
    end
  end

  def destroy
    @branch.destroy
    current_management.branches.empty? ? set_current_branch(nil) : set_current_branch(current_management.branches.first.id)
   
    redirect_to main_app.root_path 
  end

  def change
    @branch = current_management.branches.where(id: params[:branch_selector]).first
    set_current_branch(@branch.id) unless @branch.nil?
    
    redirect_to main_app.root_path 
  end

  private

    def set_branch
      @branch = current_management.branches.find(params[:id])
    end

    def branch_params
      params.require(:branch).permit(:name, branch_resources_attributes: [ :management_resource_id, :id, :selected, :_destroy ])
    end

    def check_resources
      if params[:branch][:branch_resources_attributes].present?
        params[:branch][:branch_resources_attributes].each do |key, value|
          params[:branch][:branch_resources_attributes][:"#{key}"].merge!(:_destroy => 1) if value[:selected] == "false"
        end
      end
    end 
    
end