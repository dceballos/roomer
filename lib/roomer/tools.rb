module Roomer
  class Tools
    class << self
      
      def default_search_path
        @default_search_path ||= %{"$user", public}
      end
      
      def set_search_path(*path)
        ActiveRecord::Base.connection.schema_search_path = path.join(',')
      end
      
      def create_schema(name)
        ActiveRecord::Base.connection.execute "CREATE SCHEMA #{name.to_s}"
      end
      
      def drop_schema(name)
        ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS #{name.to_s} CASCADE")
      end
      
      def schemas
        ActiveRecord::Base.connection.query("SELECT nspname FROM pg_namespace WHERE nspname !~ '^pg_.*'").flatten
      end
      
      def ensure_schema_migrations
        ActiveRecord::Base.connection.initialize_schema_migrations_table
      end
      
      def ensuring_schema(schema_name, &block)
        raise ArgumentError.new("schema_name not present") unless schema_name
        ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
        create_schema(schema_name) unless schemas.include?(schema_name.to_s)
        ActiveRecord::Base.table_name_prefix = "#{schema_name}#{Roomer.schema_seperator}"
        ensure_schema_migrations
        yield
        ActiveRecord::Base.table_name_prefix = nil
      end
      
      
    end
  end
end