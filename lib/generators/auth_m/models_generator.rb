module AuthM
  class ModelsGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../../app', __FILE__)

    def generate_models
      copy_file "models/auth_m/branch.rb", "app/models/auth_m/branch.rb"
      copy_file "models/auth_m/branch_resource.rb", "app/models/auth_m/branch_resource.rb"
      copy_file "models/auth_m/linked_account.rb", "app/models/auth_m/linked_account.rb"
      copy_file "models/auth_m/management.rb", "app/models/auth_m/management.rb"
      copy_file "models/auth_m/management_resource.rb", "app/models/auth_m/management_resource.rb"
      copy_file "models/auth_m/policy.rb", "app/models/auth_m/policy.rb"
      copy_file "models/auth_m/policy_group.rb", "app/models/auth_m/policy_group.rb"
      copy_file "models/auth_m/policy_groups_user.rb", "app/models/auth_m/policy_groups_user.rb"
      copy_file "models/auth_m/user.rb", "app/models/auth_m/user.rb"
    end
  end
end
