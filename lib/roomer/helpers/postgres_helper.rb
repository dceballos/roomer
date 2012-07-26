module Roomer
  module Helpers
    module PostgresHelper

      # Creates a schema in PostgreSQL
      # @param [#to_s] schema_name declaring the name of the schema
      def create_schema(schema_name)
        ActiveRecord::Base.connection.execute "CREATE SCHEMA \"#{schema_name.to_s}\""
      end

      # Drops a schema and all it's objects (Cascades)
      # @param [#to_s] schema_name declaring the name of the schema to drop
      def drop_schema(schema_name)
        ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS \"#{schema_name.to_s}\" CASCADE")
      end

      # lists the schemas available
      # @return [Array] list of schemas
      def schemas
        ActiveRecord::Base.connection.query(%{
          SELECT nspname FROM pg_namespace WHERE nspname !~ '^pg_.*'
        }).flatten.map(&:to_s)
      end

      # lists all stored procedures for given schema
      # @return [Array] list of stored procedures
      def stored_procedures(schema_name)
        ActiveRecord::Base.connection.select_values(%{
          SELECT  proname
          FROM    pg_catalog.pg_namespace n
          JOIN    pg_catalog.pg_proc p
            ON    pronamespace = n.oid
          WHERE   nspname = '#{schema_name.to_s}'
        })
      end

      # Ensures the schema and schema_migrations exist(creates them otherwise) 
      # and executes the code block
      # @param [#to_s] schema_name declaring name to ensure
      # @param [#call] &block code to execute
      #
      # Example:
      #
      #    ensuring_schema(:global) do
      #       ActiveRecord::Migrator.migrate('/db/migrate', '20110812012536')
      #    end
      def ensuring_schema(schema_name, &block)
        raise ArgumentError.new("schema_name not present") unless schema_name
        ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
        create_schema(schema_name) unless schemas.include?(schema_name.to_s)
        ensure_prefix(schema_name) do
          ensure_schema_migrations
          yield
        end
      end

      # Creates sequence for given table name
      # @param [table_name] table for which sequence will be created
      # @param [pk] primary key for table.  Defaults to id
      def create_sequence(table_name, pk="id")
        ActiveRecord::Base.connection.execute(%{
          CREATE SEQUENCE #{table_name}_#{pk}_seq OWNED BY #{table_name}.#{pk}
        })
      end

      # Ensures the same ActiveRecord::Base#table_name_prefix for all the 
      # models executed in the block
      # @param [#to_s] A Symbol declaring the table name prefix
      # @param [#call] code to execute
      # @note All the Models will have the same prefix, caution is advised
      #
      # Example:
      #
      #   ensure_prefix(:global) do
      #      Person.find(1)  # => will execute "SELECT id FROM 'global.person' where 'id' = 1"
      #   end
      def ensure_prefix(prefix, &block)
        old_prefix = ActiveRecord::Base.table_name_prefix
        ActiveRecord::Base.table_name_prefix = "#{prefix.to_s}#{Roomer.schema_seperator.to_s}"
        yield
        ActiveRecord::Base.table_name_prefix = old_prefix
      end

      # Ensures schema_migrations table exists and creates otherwise
      # @see ActiveRecord::Base.connection#initialize_schema_migrations_table
      def ensure_schema_migrations
        ActiveRecord::Base.connection.initialize_schema_migrations_table
      end

      # Determine if there are any pending migrations in the shared migrations directory
      # @returns true if migrations are pending
      def shared_migrations_pending?
        ActiveRecord::Migrator.new(:up,Roomer.shared_migrations_directory)
      end

    end
  end
end
