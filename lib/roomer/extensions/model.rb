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
          roomer_full_table_name_prefix(current_tenant.namespace)
        else
          ""
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
end
