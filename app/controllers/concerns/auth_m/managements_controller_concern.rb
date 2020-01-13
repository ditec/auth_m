require 'active_support/concern'

module AuthM::ManagementsControllerConcern
  extend ActiveSupport::Concern
  
  included do
    load_and_authorize_resource

    before_action :check_resources, only: [:create, :update]
  end

  def show
  end

  def new
  end

  def edit
  end
  
  def create
    @management = AuthM::Management.new(management_params)
 
    if @management.save
      set_current_management(@management.id)
      redirect_to @management
    else
      render :new
    end
  end

  def update
    if @management.update(management_params)
      redirect_to @management
    else
      render :edit
    end
  end

  def destroy
    @management.destroy
    AuthM::Management.first.nil? ?  set_current_management(nil) : set_current_management(AuthM::Management.first.id)
   
    redirect_to main_app.root_path 
  end

  def change
    set_current_management(params[:management_selector]) if AuthM::Management.exists?(params[:management_selector])
    redirect_to current_management
  end


  private

    def management_params
      params.require(:management).permit(:name, management_resources_attributes: [ :name, :id, :selected, :_destroy ])
    end

    def check_resources
      if params[:management][:management_resources_attributes].present?
        params[:management][:management_resources_attributes].each do |key, value|
          params[:management][:management_resources_attributes][:"#{key}"].merge!(:_destroy => 1) if value[:selected] == "false"
        end
      end
    end 

end