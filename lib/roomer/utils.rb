module Roomer
  module Utils

    # Rails DB Migrations Directory
    # @return [String] full path to the current migrations directory
    def migrations_directory
      ActiveRecord::Migrator.migrations_path
    end

    # Directory where the models are stored
    # @return [String] path of the directory where the models are stored
    def model_directory
      File.join("app","models")
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
    def full_shared_schema_migration_path
      "#{Rails.root}/#{shared_migrations_directory}"
    end

    # Returns tenant model as a constant
    # Example: Tenant
    # @return Object
    def tenant_model
      Roomer.tenants_table.to_s.classify.constantize
    end

    # Sets current tenant from ApplicationController into a Thread
    # local variable.  Works only with thread-safe Rails as long as
    # it gets set on every request
    # @return [Symbol] the current tenant key in the thread
    def current_tenant=(val)
      key = :"roomer_current_tenant"
      unless  Thread.current[key].try(:url_identifier) == val.url_identifier
        Thread.current[key] = val
        ensure_tenant_model_reset
      end
      Thread.current[key]
    end

    # Fetches the current tenant
    # @return [Symbol] the current tenant key in the thread
    def current_tenant
      key = :"roomer_current_tenant"
      Thread.current[key]
    end

    # Reset current tenant
    # @return [Nil]
    def reset_current_tenant
      key = :"roomer_current_tenant"
      Thread.current[key] = nil
    end

    # Reset cached data in tenanted models
    def ensure_tenant_model_reset
      reset_models
    end

    protected

    def reset_models
      ActiveRecord::Base.descendants.each do |model|
        model.roomer_reset if model.tenanted?
      end
    end

    def clean_environment
      ActionDispatch::Reloader.cleanup!
    end
  end
end
