require 'rails/generators/active_record'
module Roomer
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      class_option :model_name,   :default => :tenant
      class_option :schema_name,  :default => :global
            
      desc "Creates a Roomer initializer for your application."
      
      def copy_initializer
        template "roomer.rb", "config/initializers/roomer.rb"
      end
      
      def create_migration_file
        template "migration.rb", "db/migrate/global/roomer_create_#{options[:model_name]}.rb"
      end
      
      def show_readme
        readme "README" if behavior == :invoke
      end
      
    end
  end
end