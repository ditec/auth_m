require 'active_support/concern'

module AuthM::LinkedAccountsControllerConcern
  extend ActiveSupport::Concern
  
  included do
    authorize_resource
  end

  def unlink
    account = current_user.linked_accounts.where(provider: params[:provider]).first
    unless account.nil? 
      account.destroy
      flash[:notice] = t(".unlinked")
    end
    redirect_to auth_m.edit_user_registration_path(current_user) and return
  end

end