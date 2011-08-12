class ActiveRecord::Base
  class << self
    def table_name_prefix
      return @table_name_prefix unless @table_name_prefix.blank?
      if shared?
        Roomer.shared_schema_name
      elsif tenanted?
        self.current_tenant[Roomer.tenant_schema_name_column]
      else
        ""
      end
    end

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

    def shared?
      @roomer_scope == :shared
    end

    def tenanted?
      @roomer_scope == :tenanted
    end

    def current_tenant=(val)
      key = :"#{self}_current_tenant"
      Thread.current[key] = val
    end
    
    def current_tenant
      key = :"#{self}_current_tenant"
      Thread.current[key] || ""
    end

    def reset_current_tenant
      key = :"#{self}_current_tenant"
      Thread.current[key] = nil
    end
  end
end
