class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  protect_from_forgery with: :exception  

  helper_method :current_branch, :user_signed_in?

  rescue_from ActionController::InvalidAuthenticityToken do |exception|   
    redirect_to auth_m.new_user_session_path, alert: "Invalid Authenticity Token"
  end 

  rescue_from CanCan::AccessDenied do |exception|    
    redirect_to "/401.html" 
  end

  def after_sign_in_path_for(resource)
    session[:branch_id] = current_user.branch ? current_user.branch.id : AuthM::Branch.first.id
    main_app.root_path
  end

  def after_sign_out_path_for(resource)
    main_app.root_path
  end
  
  def current_ability
    @current_ability ||= AuthM::Ability.new(current_user)
  end

  def current_branch
    session[:branch_id] = current_user.branch ? current_user.branch.id : AuthM::Branch.first.id if session[:branch_id].nil?
    AuthM::Branch.find(session[:branch_id])
  end 

  def set_current_branch(id)
    session[:branch_id] = id 
  end

  impersonates :user
end