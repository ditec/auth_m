module AuthM
  module Generators
    class ControllersGenerator < Rails::Generators::Base

      source_root File.expand_path('../../../../app', __FILE__)

      def generate_controllers
        directory "controllers/auth_m", "app/controllers/auth_m"
      end
      
    end
  end
end
