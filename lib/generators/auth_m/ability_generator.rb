module AuthM
  module Generators
    class AbilityGenerator < Rails::Generators::Base

      source_root File.expand_path('../../../../app', __FILE__)

      def generate_ability
        copy_file "models/auth_m/ability.rb", "app/models/auth_m/ability.rb"
      end

    end
  end
end
