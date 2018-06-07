require 'active_support/concern'

module AuthM::ManagementsControllerConcern
  extend ActiveSupport::Concern
  
  included do
    load_and_authorize_resource

    before_action :set_management, except: [:new, :create, :change]
    before_action :check_resources, only: [:create, :update]
  end

  def show
  end

  def new
    @management = AuthM::Management.new
  end

  def edit
  end
  
  def create
    @management = AuthM::Management.new(management_params)
 
    if @management.save
      set_current_management(@management.id)
      redirect_to @management
    else
      render 'new'
    end
  end

  def update
    if @management.update(management_params)
      redirect_to @management
    else
      render 'edit'
    end
  end

  def destroy
    @management.destroy
    set_current_management(AuthM::Management.first.id)
   
    redirect_to main_app.root_path 
  end

  def change    
    set_current_management(params[:management_selector])    
    # path = request.referer    
    path = management_path(current_management) 
    if path.include? "management"    
      redirect_to path  
    end
  end

  private

    def management_params
      params.require(:management).permit(:name, resources_attributes: [ :name, :id, :selected, :_destroy ])
    end

    def check_resources
      if params[:management][:resources_attributes].present?
        params[:management][:resources_attributes].each do |key, value|
          params[:management][:resources_attributes][:"#{key}"].merge!(:_destroy => 1) if value[:selected] == "false"
        end
      end
    end 

    def set_management
      current_management.id == params[:id].to_i ? (@management = AuthM::Management.find(params[:id])) : (redirect_to main_app.root_path)
    end
    
end