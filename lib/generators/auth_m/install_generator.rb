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
      migration_template "migrations/auth_m_create_tables.rb", "db/migrate/auth_m_create_tables.rb"
      sleep 1
    end

    def create_route
      route "mount AuthM::Engine, at: '/auth_m' \n"
    end

    def show_readme
      sleep 1
      readme "README"
    end
  end
end
