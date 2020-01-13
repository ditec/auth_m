module AuthM
  class Engine < ::Rails::Engine
    isolate_namespace AuthM
    
    mattr_accessor :new_session_captcha, :new_registration_captcha, :new_password_captcha, :new_confirmation_captcha, :public_users
    
    config.before_initialize do                                                      
      config.i18n.load_path += Dir["#{config.root}/config/locales/*.yml"]
    end

    initializer :auth_m, before: :load_config_initializers do
      Rails.application.routes.append do
        mount AuthM::Engine, at: '/auth_m' 
      end
    end

    initializer :assets do |config|
      Rails.application.config.assets.paths << root.join("app", "assets", "javascripts", "auth_m")
      Rails.application.config.assets.paths << root.join("app", "assets", "stylesheets", "auth_m")
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, :dir => 'spec/factories'
    end

    config.after_initialize do
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
