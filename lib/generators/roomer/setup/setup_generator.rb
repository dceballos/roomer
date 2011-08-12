require 'rails/generators/active_record'
module Roomer
  module Generators
    class SetupGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      include Rails::Generators::Migration
      extend ActiveRecord::Generators::Migration
      
      def create_migration_file
        migration_template "global_migration.rb", "db/migrate/#{Roomer.shared_schema_name.to_s}/roomer_create_#{Roomer.tenants_table.to_s}"
      end
    end
  end
end