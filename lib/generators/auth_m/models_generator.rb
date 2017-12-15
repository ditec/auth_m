module AuthM
  module Generators
    class ModelsGenerator < Rails::Generators::Base

      source_root File.expand_path('../../../../app', __FILE__)

      def generate_controllers
        copy_file "models/auth_m/management.rb", "app/models/auth_m/management.rb"
        copy_file "models/auth_m/policy.rb", "app/models/auth_m/policy.rb"
        copy_file "models/auth_m/resource.rb", "app/models/auth_m/resource.rb"
        copy_file "models/auth_m/user.rb", "app/models/auth_m/user.rb"
        copy_file "models/auth_m/person.rb", "app/models/auth_m/person.rb"
      end

    end
  end
end
