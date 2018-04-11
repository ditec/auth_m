require 'active_support/concern'

module AuthM::PeopleControllerConcern
  extend ActiveSupport::Concern
  
  included do
    load_and_authorize_resource

    before_action :set_person, except: [:index, :new, :create]
  end

  def index
    @people = current_management.people.reject{|x| x.user == current_user}
    # @people = current_management.people.includes(:user).where.not({auth_m_users: {id: current_user.id}}).order("last_name")
  end

  def show
  end

  def new
    @person = AuthM::Person.new
  end

  def edit
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
    if @person.update(person_params)
      redirect_to @person
    else
      render 'edit'
    end
  end

  def destroy
    @person.destroy
   
    redirect_to people_path
  end

  private

    def person_params
      params.require(:person).permit(:first_name, :last_name, :dni, :management_id).reject{|_, v| v.blank?}
    end

    def set_person
      @person = AuthM::Person.find(params[:id])
    end

end