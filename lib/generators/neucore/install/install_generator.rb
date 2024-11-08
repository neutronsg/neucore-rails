# frozen_string_literal: true
require "rails/generators"
require "rails/generators/active_record"

class Neucore::InstallGenerator < Rails::Generators::Base
  include ::Rails::Generators::Migration

  def self.next_migration_number(dirname)
    ::ActiveRecord::Generators::Base.next_migration_number(dirname)
  end

  source_root File.expand_path("templates", __dir__)

  def copy_files
    copy_file "config.rb", "config/initializers/neucore.rb"
    copy_file "permissions.yml", "config/neucore.yml"
    copy_file 'models/admin_user.rb', 'app/models/admin_user.rb'
    copy_file 'models/admin_role.rb', 'app/models/admin_role.rb'
    copy_file 'models/admin_role_scope.rb', 'app/models/admin_role_scope.rb'
    copy_file 'models/admin_user_role.rb', 'app/models/admin_user_role.rb'

    create_migration_file('create_admin_users')
    create_migration_file('create_admin_roles')
    create_migration_file('create_admin_user_roles')
    create_migration_file('create_admin_role_scopes')
  end

  protected
  def create_migration_file template
    migration_dir = File.expand_path("db/migrate")
    if self.class.migration_exists?(migration_dir, template)
      ::Kernel.warn "Migration already exists: #{template}"
    else
      migration_template(
        "db/#{template}.rb.erb",
        "db/migrate/#{template}.rb",
        {migration_version: migration_version}
      )
    end
  end

  protected

  def migration_version
    format(
      "[%d.%d]",
      ActiveRecord::VERSION::MAJOR,
      ActiveRecord::VERSION::MINOR
    )
  end
end
