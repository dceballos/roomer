require 'rails/generators/active_record'

module Roomer
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      extend ActiveRecord::Generators::Migration
      
      source_root File.expand_path("../templates", __FILE__)

      class_option  :model_name, :aliases => "-m", :default => "tenant", 
                    :desc => "Name of tenant model" 
                   
      class_option  :schema_name, :aliases => "-s", :default => "global",
                    :desc => "Name of shared schema"
            
      desc "Creates a Roomer initializer for your application and generates the necessary migration"
      
      def copy_initializer
        template "roomer.rb", "config/initializers/roomer.rb"
      end
      
      def create_migration_file
        migration_template "migration.rb", "db/migrate/#{schema_name}/roomer_create_#{table_name}"
      end
      
      def show_readme
        readme "README" if behavior == :invoke
      end
      
      def table_name
        @table_name ||= options[:model_name].to_s.downcase.pluralize
      end
      
      def model_name
        @model_name ||= options[:model_name].to_s.downcase
      end
      
      def schema_name
        @schema_name ||= options[:schema_name].to_s.downcase
      end
      
    end
  end
end