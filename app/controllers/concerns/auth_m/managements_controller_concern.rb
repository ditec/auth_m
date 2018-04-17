require 'active_support/concern'

module AuthM::ManagementsControllerConcern
  extend ActiveSupport::Concern
  
  included do
    load_and_authorize_resource

    before_action :set_management, except: [:new, :create, :change]
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

      create_resources @management
      set_current_management(@management.id)
      redirect_to @management
    else
      render 'new'
    end
  end

  def update
    if @management.update(management_params)

      destroy_resources @management
      create_resources @management

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
      params.require(:management).permit(:name)
    end

    def destroy_resources(management)
      if params[:management][:resources].present?
        resources = management.resources.collect{|s| s.name} - params[:management][:resources]

        resources.each do |resource|
          management.resources.find_by(name: resource).destroy
        end
      end
    end

    def create_resources(management)
      if params[:management][:resources].present?
        resources = management.resources.collect{|s| s.name} 

        params[:management][:resources].reject { |r| r.empty? }.each do |a|
          management.resources.create!(name: a) unless resources.include? a
        end
      end 
    end

    def set_management
      current_management.id == params[:id].to_i ? (@management = AuthM::Management.find(params[:id])) : (redirect_to main_app.root_path)
    end
    
end