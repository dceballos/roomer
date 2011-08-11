module Roomer
  module Generators
    class InstallGenerator < Rails::Generators::Base
      
      source_root File.expand_path("../templates", __FILE__)

      class_option  :tenants_table, :aliases => "-t", :default => "tenant", 
                    :desc => "Name of tenant tables" 
                   
      class_option  :shared_schema_name, :aliases => "-s", :default => "global",
                    :desc => "Name of shared schema"
            
      desc "Creates a Roomer initializer for your application and generates the necessary migration"
      
      def tenants_table
        Roomer.tenants_table ||= options[:tenants_table].tableize
      end
      
      def shared_schema_name
        Roomer.shared_schema_name ||= options[:shared_schema_name].tableize
      end
      
      def copy_initializer
        template "roomer.rb", "config/initializers/roomer.rb"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
      
    end
  end
end