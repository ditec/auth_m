module AuthM
  class Engine < ::Rails::Engine
    isolate_namespace AuthM

    initializer "auth_m", before: :load_config_initializers do |app|
      Rails.application.routes.append do
        mount AuthM::Engine, at: "/auth_m"
      end
    end

  end
end
