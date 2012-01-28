module Roomer
  module Extensions
    module Model
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
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

        # Resets model's cached table_name and
        # column information.
        # This method needs to get called whenever
        # the current tenant changes
        def roomer_reset
          roomer_set_table_name_prefix
          reset_table_name 
          reset_column_information
          reload_environment
        end

        def reload_environment
          ActionDispatch::Reloader.cleanup!
          ActionDispatch::Reloader.prepare!
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
                roomer_full_table_name_prefix(Roomer.current_tenant.try(Roomer.tenant_schema_name_column))
              else
                ""
            end
          end
        end
      end
    end
  end
end
