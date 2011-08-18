require 'rails/generators/active_record'
module Roomer
  module Generators
    class SetupGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      extend ActiveRecord::Generators::Migration

      source_root File.expand_path("../templates", __FILE__)
      desc "Generates the shared tables db migrations under #{Roomer.shared_migrations_directory} and generates the tenant model"

      # Creates the Tenants 
      def create_tenant_model_file
        add_file File.join(Roomer.model_directory,"#{Roomer.tenants_table.to_s.singularize}.rb") do
<<-CONTENT
class #{Roomer.tenants_table.to_s.classify} < ActiveRecord::Base
  # tell roomer if this is a shared model
  roomer :shared
end
CONTENT
        end
      end

      # creates a migration file under /db/migrate/shared_schema_name
      def create_migration_file
        migration_template "global_migration.rb", "#{Roomer.shared_migrations_directory}/roomer_create_#{Roomer.tenants_table.to_s}"
      end

   end
  end
end
