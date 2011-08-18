require 'rails/generators/active_record'
module Roomer
  module Generators
    class ModelGenerator < Rails::Generators::NamedBase
      include Rails::Generators::Migration
      extend  ActiveRecord::Generators::Migration
      include Roomer::Helpers::ModelHelper

      source_root File.expand_path("../templates", __FILE__)

      argument      :attributes,  :type => :array,   :default => [],    
                    :banner => "field:type field:type"

      class_option  :shared,      :type => :boolean, :default => false, 
                    :aliases => "-s", :desc => "shared?" 

      def generate_model
        invoke "active_record:model", [name], :migration => false unless model_exists? && behavior == :invoke
      end

      def copy_roomer_migration
        if roomer_model?(name)
          info_message "model already exists in #{model_path}. skipping migration file."
        else
          migration_template "migration.rb", "#{migration_dir}/roomer_create_#{table_name}"
        end
      end

      def inject_roomer_content
        unless roomer_model?(name)
          inject_into_class model_path, class_name do
<<-CONTENT
  # tell roomer if this is a shared or tenanted model
  roomer :#{shared? ? "shared" : "tenanted"}
CONTENT
          end
        end
      end

    end
  end
end
