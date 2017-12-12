require 'rails/generators'
require 'rails/generators/migration'

module AuthM
  class InstallGenerator < Rails::Generators::Base

    include Rails::Generators::Migration

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        Time.new.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end

    def create_migration_file
      migration_template "migrations/create_auth_m_managements.rb", "db/migrate/create_auth_m_managements.rb"
      sleep 1
      migration_template "migrations/create_auth_m_resources.rb", "db/migrate/create_auth_m_resources.rb"
      sleep 1
      migration_template "migrations/devise_create_auth_m_users.rb", "db/migrate/devise_create_auth_m_users.rb"
      sleep 1
      migration_template "migrations/create_auth_m_policies.rb", "db/migrate/create_auth_m_policies.rb"
      sleep 1
      migration_template "migrations/devise_invitable_add_to_auth_m_users.rb", "db/migrate/devise_invitable_add_to_auth_m_users.rb"
      sleep 1      
      migration_template "migrations/add_management_id_to_users.rb", "db/migrate/add_management_id_to_users.rb"
      sleep 1
    end

    def show_readme
      sleep 1
      readme "README"
    end
  end
end
