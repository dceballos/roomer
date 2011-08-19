require 'rails/generators/active_record'
module ActiveRecord
  module Generators
    class RoomerGenerator < ActiveRecord::Generators::Base
      include Roomer::Helpers::ModelHelper

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


      # Generates migration file
      def copy_roomer_migration
        migration_template "migration.rb", "#{migration_dir}/roomer_create_#{table_name}"
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

    end
  end
end
