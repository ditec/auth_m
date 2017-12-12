require 'active_support/concern'

module AuthM::ManagementsControllerConcern
  extend ActiveSupport::Concern
  
  included do
    load_and_authorize_resource
  end

  def index
    @managements = AuthM::Management.all
  end

  def show
    @management = AuthM::Management.find(params[:id])
  end

  def new
    @management = AuthM::Management.new
  end

  def edit
    @management = AuthM::Management.find(params[:id])
  end
  
  def create
    @management = AuthM::Management.new(management_params)
 
    if @management.save

      create_resources @management
      redirect_to @management
    else
      render 'new'
    end
  end

  def update
    @management = AuthM::Management.find(params[:id])
   
    if @management.update(management_params)

      @management.resources.destroy_all
      create_resources @management

      redirect_to @management
    else
      render 'edit'
    end
  end

  def destroy
    @management = AuthM::Management.find(params[:id])
    @management.destroy
   
    redirect_to managements_path
  end

  def change    
    set_current_management(params[:management_selector])    
    path = request.referer    
    path = management_path(current_management) 
    if path.include? "management"    
      redirect_to path  
    end
  end

  private

    def management_params
      params.require(:management).permit(:name)
    end

    def resources_params
      params.require(:management).permit(resources:[]) 
    end

    def create_resources(management)
      if params[:management][:resources].present?
        resources_params[:resources].each do |a|
          management.resources.create!(name: a) if !(a.empty?) && (AuthM::Resource.exists? a)
        end
      end 
    end
end