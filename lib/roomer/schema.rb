require 'active_support/core_ext/object/blank'
require 'ftools'

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
      File.mkpath(Roomer.schemas_directory) unless Dir.exists?(Roomer.schemas_directory)
      filepath = File.expand_path(File.join(Roomer.schemas_directory, filename))
      ActiveRecord::Base.connection.schema_search_path = schema_name
      ActiveRecord::Base.table_name_prefix = "#{schema_name}."
      Roomer::SchemaDumper.dump(ActiveRecord::Base.connection, File.new(filepath, "w"))
    end

    def self.load(schema_name, scope=:tenanted)
      filename = begin
        if scope == :shared
          Roomer.shared_schema_filename
        elsif scope == :tenanted
          Roomer.tenanted_schema_filename
        end
      end
      filepath = File.expand_path(File.join(Roomer.schemas_directory, filename))
      return unless File.exists?(filepath)

      ensuring_schema(schema_name) do
        Object.load(filepath) 
      end
    end

    def self.define(info={}, &block)
      instance_eval(&block)
      unless info[:version].blank?
        ActiveRecord::Base.connection.assume_migrated_upto_version(info[:version], migrations_path)
      end
    end
  end
end
