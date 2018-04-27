class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  protect_from_forgery with: :exception  

  helper_method :current_management, :user_signed_in?

  rescue_from ActionController::InvalidAuthenticityToken do |exception|   
    redirect_to auth_m.new_user_session_path, alert: "Invalid Authenticity Token"
  end 

  rescue_from CanCan::AccessDenied do |exception|    
    redirect_to "/401.html" 
  end

  def after_sign_in_path_for(resource)
    session[:management_id] = current_user.management ? current_user.management.id : AuthM::Management.first.id
    main_app.root_path
  end

  def after_sign_out_path_for(resource)
    main_app.root_path
  end
  
  def current_ability
    @current_ability ||= AuthM::Ability.new(current_user)
  end

  def current_management
    session[:management_id] = current_user.management ? current_user.management.id : AuthM::Management.first.id if session[:management_id].nil?
    AuthM::Management.find(session[:management_id])
  end 

  def set_current_management(id)
    session[:management_id] = id 
  end

  impersonates :user
end