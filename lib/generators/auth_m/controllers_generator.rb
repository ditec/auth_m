module AuthM
  module Generators
    class ControllersGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      def generate_controllers
        directory "controllers", "app/controllers"
      end

    end
  end
end
