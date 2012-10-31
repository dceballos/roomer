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
          roomer_initialize_model!
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
          roomer_reset_table_name
          reset_column_information
          reset_associations
        end

        protected

        # Save the table name declared by `set_table_name`.
        def roomer_initialize_model!
          @roomer_original_table_name = @table_name
          roomer_set_table_name_prefix
        end

        # Reset original table name.
        #
        # reset_table_name will not acknowledge the newly-changed
        # table_name_prefix if set_table_name was used.
        #
        def roomer_reset_table_name
          if @roomer_original_table_name
            self.table_name = "#{table_name_prefix}#{@roomer_original_table_name}"
          else
            reset_table_name
          end
        end

        # Resets cached data in associations
        # Fixes bug that mixed table_name_prefix
        # between tenants
        def reset_associations
          reflections.each_value do |r|
            r.instance_variable_set(:@quoted_table_name, nil)
            table_name = r.instance_variable_get(:@table_name)
            if (table_name)
              table_name = table_name.split(".").last
              klass = r.class_name.constantize
              schema_name   = klass.tenanted? ? Roomer.current_tenant.try(:schema_name) : Roomer.shared_schema_name
              schema_name &&= schema_name.to_s
              schema_name ||= "__no_tenant__"
              table_name = "#{schema_name}#{Roomer.schema_seperator}#{table_name}"
              r.instance_variable_set(:@table_name, table_name)
              r.instance_variable_set(:@quoted_table_name, connection.quote_table_name(table_name))
            end
          end
        end

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
