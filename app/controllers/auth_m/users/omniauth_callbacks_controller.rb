module AuthM
  class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # You should configure your model like this:
    # devise :omniauthable, omniauth_providers: [:twitter]

    # You should also create an action method in this controller like this:

    def facebook
      if request.env["omniauth.auth"].info.email.blank?
        redirect_to "/auth_m/users/auth/facebook?auth_type=rerequest&scope=email"
        return
      else
        callback_from :facebook
      end
    end

    def google_oauth2
      callback_from :google_oauth2
    end

    def twitter
      callback_from :twitter
    end

    def failure
      redirect_to new_user_session_path, notice: t("users.omniauth_callbacks.login_failed")
    end

    def custom_sign_up
      if !(session["devise.auth.uid"].nil?) && !(session["devise.auth.provider"].nil?) && AuthM::Engine.public_users == true
        @user = AuthM::User.new(user_params.merge(active: true, confirmed_at: DateTime.now.to_date))

        if @user.save 
          @user.linked_accounts.create(uid: session["devise.auth.uid"], provider: session["devise.auth.provider"])
          sign_in_and_redirect @user, event: :authentication
        else 
          render :edit
        end
      else
        failure
      end
    end

    private

      def callback_from(provider)
        provider = provider.to_s
        
        if user_signed_in?
          if current_user.link_account_from_omniauth(request.env["omniauth.auth"])
            flash[:notice] = t("users.omniauth_callbacks.success")
          else
            flash[:alert] = current_user.errors.full_messages.join(", ")
          end
          redirect_to auth_m.edit_user_registration_path(current_user)
        else
          @user = AuthM::User.from_omniauth(request.env["omniauth.auth"])
          if @user  
            sign_in_and_redirect @user, event: :authentication
            set_flash_message(:notice, :success, :kind => provider.split("_").first.capitalize) if is_navigational_format?
          elsif AuthM::Engine.public_users == true
            @user = AuthM::User.new(email:request.env["omniauth.auth"].info.email)
            session["devise.auth.uid"] = request.env["omniauth.auth"].uid
            session["devise.auth.provider"] = request.env["omniauth.auth"].provider

            render :edit
          else
            redirect_to new_user_session_path, alert: t("auth_m.public_users.res_disabled")
          end
        end
      end

      def user_params 
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
      end
  end
end
