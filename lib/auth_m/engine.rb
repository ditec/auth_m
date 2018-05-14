module AuthM
  class Engine < ::Rails::Engine
    isolate_namespace AuthM
    
    mattr_accessor :new_session_captcha, :new_registration_captcha, :new_password_captcha, :new_confirmation_captcha

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, :dir => 'spec/factories'
    end

    config.after_initialize do
      mattr_accessor :new_session_captcha, :new_registration_captcha, :new_password_captcha, :new_confirmation_captcha

      middleware.use OmniAuth::Builder do
        provider :facebook, Rails.application.secrets.FACEBOOK_KEY, Rails.application.secrets.FACEBOOK_SECRET, scope: 'public_profile,email', info_fields: 'email,first_name,last_name'
        provider :google_oauth2, Rails.application.secrets.GOOGLE_KEY, Rails.application.secrets.GOOGLE_SECRET
        provider :twitter, Rails.application.secrets.TWITTER_KEY, Rails.application.secrets.TWITTER_SECRET
      end
    end

    def self.setup
      yield self
    end
  end
end
