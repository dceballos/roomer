module Roomer
  module Model
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # Sets the roomer scope for the model and changes the model's table_name_prefix
      # Includes Roomer::Model mixin
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

      # Sets the model's table name prefix to the current tenant's schema name
      # It defaults to public if model is marked as tenanted but tenant table
      # hasn't been populated
      def roomer_set_table_name_prefix
        self.table_name_prefix = begin
          case @roomer_scope
            when :shared
              roomer_full_table_name_prefix(Roomer.shared_schema_name)
            when :tenanted
              roomer_full_table_name_prefix(current_tenant.try(:namespace) || "public")
            else
              ""
          end
        end
      end
    end
  end
end
