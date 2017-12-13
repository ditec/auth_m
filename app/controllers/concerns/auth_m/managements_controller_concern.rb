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

      destroy_resources @management
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

    def destroy_resources(management)
      if params[:management][:resources].present?
        resources = management.resources.collect{|s| s.name} - params[:management][:resources]

        resources.each do |resource|
          AuthM::Resource.find_by(name: resource).destroy
        end
      end
    end

    def create_resources(management)
      if params[:management][:resources].present?
        resources = management.resources.collect{|s| s.name} 

        params[:management][:resources].each do |a|
          management.resources.create!(name: a) if !(a.empty?) && (AuthM::Resource.exists? a) && !(resources.include? a)
        end
      end 
    end
end