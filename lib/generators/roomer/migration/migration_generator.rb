require 'active_record/migration'
require 'rails/generators/active_record'
module Roomer
  module Generators
    class MigrationGenerator < Rails::Generators::NamedBase
      include Rails::Generators::Migration
      # commented out for for rails 4.0 can probably be uncommented for 4.1
      # extend  ActiveRecord::Generators::Migration
      extend  ActiveRecord::Generators # rails 4.0 specific
      include Roomer::Helpers::GeneratorHelper

      source_root File.expand_path("../templates", __FILE__)

      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      class_option  :shared,      :type => :boolean, :default => false,
                    :aliases => "-s", :desc => "shared?"

      # needed for rails 4.0 can probably be removed for 4.1
      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end
      
      # Generates the migration
      def create_migration_file
        set_local_assigns!
        # migration_template "migration.rb", "#{migration_dir}/roomer_#{file_name}"
        # had to append the .rb for rails 4.0
        migration_template "migration.rb", "#{migration_dir}/roomer_#{file_name}.rb"
      end

      protected
        attr_reader :migration_action

        def set_local_assigns!
          if file_name =~ /^(add|remove)_.*_(?:to|from)_(.*)/
            @migration_action = $1
            @table_name       = $2.pluralize
          end
        end
      
    end
  end
end
