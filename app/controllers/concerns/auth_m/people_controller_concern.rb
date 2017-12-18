require 'active_support/concern'

module AuthM::PeopleControllerConcern
  extend ActiveSupport::Concern
  
  included do
    load_and_authorize_resource
  end

  def index
    @people = current_management.people.joins(:user).where.not(auth_m_users:{id:current_user.id}).paginate(:page => params[:page], :per_page => 10) 
  end

  def show
    @person = AuthM::Person.find(params[:id])
  end

  def new
    @person = AuthM::Person.new
  end

  def edit
    @person = AuthM::Person.find(params[:id])
  end
  
  def create
    @person = AuthM::Person.new(person_params)
    @person.management = current_management

    if @person.save
      redirect_to @person
    else
      render 'new'
    end
  end

  def update
    @person = AuthM::Person.find(params[:id])
   
    if @person.update(person_params)
      redirect_to @person
    else
      render 'edit'
    end
  end

  def destroy
    @person = AuthM::Person.find(params[:id])
    @person.destroy
   
    redirect_to people_path
  end

  private

    def person_params
      params.require(:person).permit(:first_name, :last_name, :dni)
    end

end