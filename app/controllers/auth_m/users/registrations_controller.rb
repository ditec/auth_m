module AuthM
  class Users::RegistrationsController < Devise::RegistrationsController
    prepend_before_action :check_captcha, only: [:create] if AuthM::Engine.new_registration_captcha == true
    prepend_before_action :public_users_disabled, only: [:new, :create] if AuthM::Engine.public_users == false
    
    # before_action :configure_sign_up_params, only: [:create]
    # before_action :configure_account_update_params, only: [:update]

    # GET /resource/sign_up
    # def new
    #   super
    # end

    # POST /resource
    # def create
    #   super
    # end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #   super
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    protected

    def after_update_path_for(resource)
      main_app.root_path
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_up_params
    #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
    # end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
    # end

    # The path used after sign up.
    def after_sign_up_path_for(resource)
      main_app.root_path
    end

    # The path used after sign up for inactive accounts.
    def after_inactive_sign_up_path_for(resource)
      main_app.root_path
    end

    private

      def check_captcha
        unless verify_recaptcha
          self.resource = resource_class.new sign_up_params
          render :new
        end 
      end

      def public_users_disabled
        redirect_to main_app.root_path, alert: t("auth_m.public_users.res_disabled") and return
      end
  end
end
