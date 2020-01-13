module AuthM
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../../lib/generators/auth_m/templates', __FILE__)

    def create_initializers
      copy_file "initializers/auth_m.rb", "config/initializers/auth_m.rb"
    end

    def show_readme
      sleep 1
      readme "README"
    end
  end
end