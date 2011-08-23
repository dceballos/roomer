require 'rails/generators/active_record'
module Roomer
  module Generators
    class SetupGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      extend ActiveRecord::Generators::Migration

      source_root File.expand_path("../templates", __FILE__)
      desc "Generates the shared tables db migrations under #{Roomer.shared_migrations_directory} and generates the tenant model"

      # Creates the Tenants model file under /app/models
      def create_tenant_model_file
        add_file File.join(Roomer.model_directory,"#{Roomer.tenants_table.to_s.singularize}.rb") do
<<-CONTENT
class #{Roomer.tenants_table.to_s.classify} < ActiveRecord::Base
  # load tenanted schema.rb file to provision new tenant
  after_create :load_schema

  # tell roomer if this is a shared model
  roomer :shared

  protected
  def load_schema
    Roomer::Schema.load(schema_name)
  end
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
