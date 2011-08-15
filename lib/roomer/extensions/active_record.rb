class ActiveRecord::Base

  class << self
    # Overrides ActiveRecord::Base.table_name_prefix
    # Defaults to blank if roomer class method is not set in model
    # Returns the shared schema name prefix if roomer method is set to :shared
    # Returns the current tenants schema name if roomer class method is set to :tenanted
    # @return [String] shared schema name prefix or current tenants schema name 
    def table_name_prefix
      return @table_name_prefix unless @table_name_prefix.blank?
      if shared?
        roomer_full_table_name_prefix(Roomer.shared_schema_name)
      elsif tenanted?
        if current_tenant.blank?
          raise "No current tenant found.  Try #{self.to_s}.current_tenant = \#\{tenant\}"
        end
        roomer_full_table_name_prefix(current_tenant.namespace)
      else
        ""
      end
    end

    # Sets the roomer scope for the model and changes the model's table_name_prefix
    # If :shared is passed, the global schema will be used as the table name prefix
    # if :tenanted is pased, the current tenant's schema will be used as the table name prefix
    # @return [Symbol] :shared or :tenanted
    def roomer(scope)
      case scope
        when :shared
          @roomer_scope = :shared
        when :tenanted
          @roomer_scope = :tenanted
        else
          raise "Invalid roomer model scope.  Choose :shared or :tenanted"
      end
    end

    # Confirms if model is shared
    # @return [True,False]
    def shared?
      @roomer_scope == :shared
    end

    # Confirms if model is scoped by tenant
    # @return [True,False]
    def tenanted?
      @roomer_scope == :tenanted
    end

    # Sets current tenant from ApplicationController into a Thread
    # local variable.  Works only with thread-safe Rails as long as
    # it gets set on every request
    # @return [Symbol] the current tenant key in the thread
    def current_tenant=(val)
      key = :"current_tenant"
      Thread.current[key] = val
    end
   
    # Fetches the current tenant
    # @return [Symbol] the current tenant key in the thread
    def current_tenant
      key = :"current_tenant"
      Thread.current[key]
    end

    # Reset current tenant
    # @return [Nil]
    def reset_current_tenant
      key = :"current_tenant"
      Thread.current[key] = nil
    end

    protected
    def roomer_full_table_name_prefix(schema_name)
      "#{schema_name.to_s}#{Roomer.schema_seperator}"
    end
  end
end
