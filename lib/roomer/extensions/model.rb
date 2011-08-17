module Roomer
  module Model
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
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
          # FIXME: should be
          # current_tenant.send(Roomer.tenant_schema_name_column)
          roomer_full_table_name_prefix(current_tenant.namespace)
        else
          ""

      # Sets the roomer scope for the model and changes the model's table_name_prefix
      # Sets the table name prefix (schema name) to current_tenant's
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
        roomer_set_table_name_prefix
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

      protected
      # Resolves the full table name prefix
      def roomer_full_table_name_prefix(schema_name)
        "#{schema_name.to_s}#{Roomer.schema_seperator}"
      end

      # Sets the model's table name prefix to the current tenant's schema name
      # Defaults to public if model is marked as tenanted but tenant table
      # hasn't been populated
      def roomer_set_table_name_prefix
        self.table_name_prefix = begin
          case @roomer_scope
            when :shared
              roomer_full_table_name_prefix(Roomer.shared_schema_name)
            when :tenanted
              unless Roomer.current_tenant
                puts "[WARNING] Roomer.current_tenant is nil.  Set with Roomer.current_tenant="
              end
              roomer_full_table_name_prefix(Roomer.current_tenant.try(:schema_name) || "public")
            else
              ""
          end
        end
      end
    end
  end
end
