module Roomer
  class Tools
    class << self
      
      def default_search_path
        @default_search_path ||= %{"$user", public}
      end
      
      def set_search_path(*path)
        ActiveRecord::Base.connection.schema_search_path = path.join(',')
      end
      
      # creates the shares schema if it doesn't exist
      def create_shared_schema
        create_schema(Roomer.shared_schema_name.to_s) unless schemas.include?(Roomer.shared_schema_name.to_s)
      end
      
      def create_schema(name)
        ActiveRecord::Base.connection.execute "CREATE SCHEMA #{name}"
      end
      
      def schemas
        ActiveRecord::Base.connection.query("SELECT nspname FROM pg_namespace WHERE nspname !~ '^pg_.*'").flatten
      end
    end
  end
end