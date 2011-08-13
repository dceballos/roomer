module Roomer
  class Tools
    class << self
            
      # Creates a schema in PostgreSQL
      # @param [#to_s] schema_name declaring the name of the schema
      def create_schema(schema_name)
        ActiveRecord::Base.connection.execute "CREATE SCHEMA #{schema_name.to_s}"
      end
      
      # Drops a schema and all it's objects (Cascades)
      # @param [#to_s] schema_name declaring the name of the schema to drop
      def drop_schema(schema_name)
        ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS #{name.to_s} CASCADE")
      end
      
      # lists the schemas available
      # @return [Array] list of schemas
      def schemas
        ActiveRecord::Base.connection.query("SELECT nspname FROM pg_namespace WHERE nspname !~ '^pg_.*'").flatten
      end
      
      # Ensures the schema and schema_migrations exist(creates them otherwise) 
      # and executes the code block
      # @param [#to_s] schema_name declaring name to ensure
      # @param [#call] &block code to execute
      # @example
      #    ensuring_schema(:global) do
      #       ActiveRecord::Migrator.migrate('/db/migrate', '20110812012536')
      #    end
      def ensuring_schema(schema_name, &block)
        raise ArgumentError.new("schema_name not present") unless schema_name
        ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
        create_schema(schema_name) unless schemas.include?(schema_name.to_s)
        ActiveRecord::Base.table_name_prefix = "#{schema_name.to_s}#{Roomer.schema_seperator.to_s}"
        ensure_prefix(schema_name) do
          ensure_schema_migrations
          yield
        end
      end
       
      # Ensures the same ActiveRecord::Base#table_name_prefix for all the 
      # models executed in the block
      # @param [#to_s] A Symbol declaring the table name prefix
      # @param [#call] code to execute
      # @note All the Models will have the same prefix, caution is advised
      # @example
      #   ensure_prefix(:global) do
      #      Person.find(1)  # => will execute "SELECT id FROM 'global.person'"
      #   end
      def ensure_prefix(prefix, &block)
        ActiveRecord::Base.table_name_prefix = "#{prefix.to_s}#{Roomer.schema_seperator}"
        yield
        ActiveRecord::Base.table_name_prefix = nil
      end
      
      # Ensures schema_migrations table exists and creates otherwise
      # @see ActiveRecord::Base.connection#initialize_schema_migrations_table
      def ensure_schema_migrations
        ActiveRecord::Base.connection.initialize_schema_migrations_table
      end
      
    end
  end
end