require 'rails/generators/active_record'
module Roomer
  module Generators
    class ModelGenerator < Rails::Generators::NamedBase
      include Rails::Generators::Migration
      extend  ActiveRecord::Generators::Migration
      include Roomer::Helpers::GeneratorHelper

      source_root File.expand_path("../templates", __FILE__)

      argument      :attributes,  :type => :array,   :default => [],
                    :banner => "field:type field:type"

      class_option  :shared,      :type => :boolean, :default => false,
                    :aliases => "-s", :desc => "shared?"

      # Generates the active record model
      # without the migration
      def generate_model
        invoke "active_record:model", [name], :migration => false unless model_exists? && behavior == :invoke
      end

      # Injects the roomer method to the class
      # Example:
      #   rails generate roomer:model person --shared # will Generate
      #   class Person < ActiveRecord::Base
      #     roomer :shared
      #   end
      def inject_roomer_content
        inject_into_class model_path, class_name do
<<-CONTENT
  # tell roomer if this is a shared or tenanted model
  roomer :#{shared? ? "shared" : "tenanted"}
CONTENT
        end
      end

      # Generates migration file of the model
      def copy_roomer_migration
        migration_template "migration.rb", "#{migration_dir}/roomer_create_#{table_name}"
      end

    end
  end
end
