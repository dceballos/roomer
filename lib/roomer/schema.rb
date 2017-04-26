require 'active_support/core_ext/object/blank'

module Roomer
  # Roomer::Schema extends ActiveRecord::Schema
  # Roomer::Schema is currently only supported by the Postgres database adapter

  class Schema < ActiveRecord::Migration
    extend Roomer::Helpers::PostgresHelper

    def self.migrations_path(scope=:tenanted)
      case scope
        when :shared
          return Roomer.shared_migrations_directory
        when :tenanted
          return Roomer.tenanted_migrations_directory
        else
          raise 'Invalid scope parameter'
      end
    end

    def self.dump(scope=:tenanted)
      unless Roomer.heroku_safe && ENV['HEROKU_UPID']
        case scope
          when :shared
            schema_name = Roomer.shared_schema_name.to_s
            filename = Roomer.shared_schema_filename
          when :tenanted
            tenant = Tenant.first
            return if tenant.blank?

            schema_name = Tenant.first.schema_name.to_s
            filename = Roomer.tenanted_schema_filename
        end
        FileUtils.mkdir_p(Roomer.schemas_directory) unless File.exists?(Roomer.schemas_directory)
        filepath = File.expand_path(File.join(Roomer.schemas_directory, filename))
        ActiveRecord::Base.connection.schema_search_path = schema_name
        Roomer::SchemaDumper.dump(ActiveRecord::Base.connection, File.new(filepath, "w"))
      end
    end

    def self.load(schema_name, scope=:tenanted)
      ensuring_schema_and_search_path(schema_name) do
        filename = begin
          if scope == :shared
            Roomer.shared_schema_filename
          elsif scope == :tenanted
            Roomer.tenanted_schema_filename
          end
        end
        filepath = File.expand_path(File.join(Roomer.schemas_directory, filename))
        return unless File.exists?(filepath)
        # Object.load(filepath)
        Object.send(:load, filepath)
      end
    end

    def self.define(info={}, &block)
      instance_eval(&block)
      unless info[:version].blank?
        ActiveRecord::Base.connection.assume_migrated_upto_version(info[:version], migrations_path)
      end
    end

    def self.current_schema
      ActiveRecord::Base.connection.schema_search_path.split(",")[0]
    end

    def self.current_tenant
      return nil if current_schema == Roomer.shared_schema_name.to_s
      Tenant.find_by_schema_name(current_schema)
    end

  end
end
