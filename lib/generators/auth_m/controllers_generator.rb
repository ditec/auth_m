module AuthM
  class ControllersGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../../app', __FILE__)

    def generate_controllers
      directory "controllers/auth_m/users", "app/controllers/auth_m/users"

      copy_file "controllers/auth_m/branches_controller.rb", "app/controllers/auth_m/branches_controller.rb"
      copy_file "controllers/auth_m/linked_accounts_controller.rb", "app/controllers/auth_m/linked_accounts_controller.rb"
      copy_file "controllers/auth_m/managements_controller.rb", "app/controllers/auth_m/managements_controller.rb"
      copy_file "controllers/auth_m/policy_groups_controller.rb", "app/controllers/auth_m/policy_groups_controller.rb"
      copy_file "controllers/auth_m/public_users_controller.rb", "app/controllers/auth_m/public_users_controller.rb"
      copy_file "controllers/auth_m/users_controller.rb", "app/controllers/auth_m/users_controller.rb"
    end
  end
end
