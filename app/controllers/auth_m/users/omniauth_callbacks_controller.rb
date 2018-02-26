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

    # More info at:
    # https://github.com/plataformatec/devise#omniauth

    # GET|POST /resource/auth/twitter
    # def passthru
    #   super
    # end

    # GET|POST /users/auth/twitter/callback
    def failure
      redirect_to new_user_session_path, notice: "Sorry, We couldn't log you in"
    end

    # protected

    # The path used when OmniAuth fails
    # def after_omniauth_failure_path_for(scope)
    #   super(scope)
    # end

    def custom_sign_up
      if !(session["devise.auth.uid"].nil?) && !(session["devise.auth.provider"].nil?)
        @person = AuthM::Person.new(person_params)
        @user = AuthM::User.new(email: user_params[:email])

        if @person.save 
          @user = @person.build_user(user_params.merge(active: true, confirmed_at: DateTime.now.to_date))
          if @user.save 
            @user.linked_accounts.create(uid: session["devise.auth.uid"], provider: session["devise.auth.provider"])
            sign_in_and_redirect @user, event: :authentication
          else 
            @person.destroy
            render :edit
          end
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
            flash[:notice] = "Account successfully linked"
          else
            flash[:notice] = "Account is already linked :O"
          end
          redirect_to auth_m.edit_user_registration_path(current_user) and return

        else
          @user = AuthM::User.from_omniauth(request.env["omniauth.auth"])
          unless @user.nil?  
            sign_in_and_redirect @user, event: :authentication
          else 
            @user = AuthM::User.new(email:request.env["omniauth.auth"].info.email)
            if provider = :twitter
              fullname = request.env["omniauth.auth"].info.name.split(' ')
              first_name, last_name = fullname[0], fullname[1]
            else
              first_name, last_name = request.env["omniauth.auth"].info.first_name, request.env["omniauth.auth"].info.last_name
            end  
            @person = AuthM::Person.new(first_name: first_name, last_name: last_name)
            session["devise.auth.uid"] = request.env["omniauth.auth"].uid
            session["devise.auth.provider"] = request.env["omniauth.auth"].provider

            render :edit
          end
        end
      end

      def person_params
        params.require(:person).permit(:first_name, :last_name, :dni).reject{|_, v| v.blank?}
      end

      def user_params 
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
  end
end
