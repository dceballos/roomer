module Roomer
  module Utils
    
    # Rails DB Migrations Directory
    # @return [String] full path to the migrations directory
    def migrations_directory
      File.join("db","migrate")
    end

    # Consutructs the full name for the tenants table with schema 
    # Example: 'global.tenant'
    # @return [String] full name of the tenant table
    def full_tenants_table_name
      "#{shared_schema_name}#{schema_seperator}#{tenants_table}"
    end

    # Constructs the full path to the shared schema directory
    # Example: /Users/Greg/Projects/roomer/db/migrate/global  
    # @return [String] full path to the shared schema directory
    def full_shared_shema_migration_path
      "#{Rails.root}/#{shared_migrations_directory}"
    end
  end
end