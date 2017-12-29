class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  require 'will_paginate/array'

  helper_method :current_management, :user_signed_in?

  rescue_from CanCan::AccessDenied do |exception|    
    redirect_to "/401.html"
  end

  def current_ability
    @current_ability ||= AuthM::Ability.new(current_user)
  end

  def after_sign_in_path_for(resource)
    if current_user.active
      session[:management_id] = current_user.management ? current_user.management.id : AuthM::Management.first.id
      main_app.root_path
    else
      sign_out resource
      flash[:alert] = "This account is not active.."
      main_app.root_path
    end
  end

  def after_sign_out_path_for(resource)
    main_app.root_path
  end

  def current_management
    if session[:management_id].nil?
      session[:management_id] = current_user.management ? current_user.management.id : AuthM::Management.first.id 
    end
    
    AuthM::Management.find(session[:management_id])
  end 

  def set_current_management(id)
    session[:management_id] = id 
  end

  impersonates :user

end
