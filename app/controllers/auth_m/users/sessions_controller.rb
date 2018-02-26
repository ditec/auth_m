module AuthM
  class Users::SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]
    before_action :check_user, only: :create

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end

    private

      def check_user
        user = AuthM::User.find_by_email(params[:user][:email])
        if (user) && !(user.confirmed?)
          redirect_to new_confirmation_path(:user), alert: "Unconfirmed e-mail"
        elsif (user) && !(user.active) 
          redirect_to main_app.root_path, alert: "Inactive account"
        end
      end
  end
end
