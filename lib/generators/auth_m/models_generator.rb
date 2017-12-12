module AuthM
  module Generators
    class ModelsGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      def generate_models
        directory "models", "app/models"
      end

    end
  end
end
