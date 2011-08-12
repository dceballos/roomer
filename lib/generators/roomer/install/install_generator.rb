module Roomer
  module Generators
    class InstallGenerator < Rails::Generators::Base
      
      source_root File.expand_path("../templates", __FILE__)

      class_option  :tenants_table, :aliases => "-t", :default => "tenants", 
                    :desc => "Name of tenant tables" 
                   
      class_option  :shared_schema_name, :aliases => "-s", :default => "global",
                    :desc => "Name of shared schema"
            
      desc "Creates a Roomer initializer for your application and generates the necessary migration"
      
      # Reads the tenants-table option and assigns it to Roomer.tenants_table config parameter
      # @return [Symbol] tenants table name
      def tenants_table
        Roomer.tenants_table ||= options[:tenants_table].to_s
      end
      
      # Reads the shared-schema-name and assigns it to Roomer.shared_schema_name
      # @return [Symbol] shared schema name
      def shared_schema_name
        Roomer.shared_schema_name ||= options[:shared_schema_name].to_s
      end
      
      # Generates the Initializer under config/initializers/roomer.rb
      def copy_initializer
        template "roomer.rb", "config/initializers/roomer.rb"
      end

      # Displays the instructions for setting up Roomer
      def show_readme
        readme "README" if behavior == :invoke
      end
      
    end
  end
end