module AuthM
  module Generators
    class ViewsGenerator < Rails::Generators::Base

      source_root File.expand_path('../../../../app', __FILE__)

      def generate_controllers
        directory "views", "app/views"
      end

    end
  end
end
