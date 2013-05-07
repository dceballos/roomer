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
    # local variable.
    # @return current tenant
    def current_tenant=(tenant)
      reset_current_tenant && return if tenant.nil?
      unless  Thread.current[current_tenant_key].try(:schema_name) == tenant.try(:schema_name)
        Thread.current[current_tenant_key] = tenant
      end
      ActiveRecord::Base.connection.set_roomer_search_path
      Thread.current[current_tenant_key]
    end

    # Fetches the current tenant
    # @return current tenant
    def current_tenant
      Thread.current[current_tenant_key]
    end

    # Reset current tenant
    # @return [Nil]
    def reset_current_tenant
      Thread.current[current_tenant_key] = nil
      ActiveRecord::Base.connection.reset_roomer_search_path
      nil
    end

    # Replace current_tenant with @tenant
    # during the execution of @blk
    def with_tenant(tenant,&blk)
      orig = self.current_tenant
      begin
        self.current_tenant = tenant
        return blk.call(tenant)
      ensure
        self.current_tenant = orig
      end
    end

    def with_tenant_from_request(request,&blk)
      with_tenant(tenant_from_request(request),&blk)
    end

    def tenant_from_request(request)
      identifier = identifier_from_request(request)
      tenant     = tenant_from_identifier(identifier)
      if !tenant
        raise Roomer::Error, "No tenant found for '#{identifier}' url identifier"
      end
      return tenant
    end

    def tenant_from_identifier(identifier)
      tenant_model.find_by_url_identifier(identifier)
    end

    def identifier_from_request(request)
      unless Roomer.url_routing_strategy == :domain
        raise Roomer::Error.new("Unsupported routing strategy")
      end
      return request.host
    end

    protected
    
    def current_tenant_key
      :roomer_current_tenant
    end
  end
end
