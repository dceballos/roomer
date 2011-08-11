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
        unless schemas.include?(name.to_s)
          ActiveRecord::Base.connection.execute "CREATE SCHEMA #{name.to_s}"
        end
        ensure_schema_migration(name.to_s)
      end
      
      def drop_schema(name)
        ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS #{name.to_s} CASCADE")
      end
      
      def schemas
        ActiveRecord::Base.connection.query("SELECT nspname FROM pg_namespace WHERE nspname !~ '^pg_.*'").flatten
      end``
      
      def ensure_schema_migration(schema)
        ActiveRecord::Base.table_name_prefix = "#{schema}."
        ActiveRecord::Base.connection.initialize_schema_migrations_table
      end
      
    end
  end
end