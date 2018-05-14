module AuthM
  class Users::RegistrationsController < Devise::RegistrationsController
    prepend_before_action :check_captcha, only: [:create] if AuthM::Engine.new_registration_captcha == true
    
    before_action :configure_sign_up_params, only: [:create]

    # before_action :configure_account_update_params, only: [:update]

    # GET /resource/sign_up
    def new
      @person = AuthM::Person.new
      super
    end

    # POST /resource
    def create
      @person = AuthM::Person.new(person_params)
      if @person.save
        params[:user] = params[:user].merge(person_id: @person.id)
        super
        create_policies resource if resource.persisted?
        @person.destroy if ((@person.persisted? ) && !(resource.persisted?))
      else
        @person.destroy if @person.persisted?
        self.resource = resource_class.new sign_up_params
        render :new
      end
    end

    # GET /resource/edit
    def edit
      @person = current_user.person
      super
    end

    # PUT /resource
    def update
      @person = resource.person

      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
      prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
      resource_updated = @person.update(person_params) && update_resource(resource, account_update_params)
      yield resource if block_given?
      if resource_updated
        if is_flashing_format?
          flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
            :update_needs_confirmation : :updated
          set_flash_message :notice, flash_key
        end
        bypass_sign_in resource, scope: resource_name
        respond_with resource, location: after_update_path_for(resource)
      else
        clean_up_passwords resource
        set_minimum_password_length
        render :edit
      end
    end

    # DELETE /resource
    def destroy
      resource.person.destroy
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      set_flash_message! :notice, :destroyed
      yield resource if block_given?
      respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
    end

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
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:person_id])
    end

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

    def person_params
      params.require(:person).permit(:first_name, :last_name, :dni)
    end
    
    def check_captcha
      unless verify_recaptcha
        self.resource = resource_class.new sign_up_params
        @person = AuthM::Person.new(person_params)
        render :new
      end 
    end

    def create_policies(user)
      user.management.resources.each do |resource|
        user.policies.create!(resource: resource, access: resource.access) if resource.default
      end 
    end    

  end
end
