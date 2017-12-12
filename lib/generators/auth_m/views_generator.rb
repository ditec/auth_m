module AuthM
  module Generators
    class ViewsGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      def generate_views
        directory "views", "app/views"
      end

    end
  end
end
