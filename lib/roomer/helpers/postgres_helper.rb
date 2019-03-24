module Roomer
  module Helpers
    module PostgresHelper
      # Set search path to Roomer.current_tenant's schema
      # @return search_path csv list
      def set_roomer_search_path
        paths = ["public"]
        if (schema_exists?(Roomer.shared_schema_name.to_s))
          paths.unshift(Roomer.shared_schema_name.to_s)
        end
        if (Roomer.current_tenant)
          if (schema_exists?(Roomer.current_tenant.schema_name.to_s))
            paths.unshift(Roomer.current_tenant.schema_name.to_s)
          end
        end
        path_string = paths.join(",")
        return self.schema_search_path if self.schema_search_path == path_string
        self.schema_search_path = path_string
      end

      # Reset search path to Roomer's shared search schema
      # @return search_path csv list
      def reset_roomer_search_path
        paths = ["public"]
        if (schema_exists?(Roomer.shared_schema_name.to_s))
          paths.unshift(Roomer.shared_schema_name.to_s)
        end
        path_string = paths.join(",")
        return self.schema_search_path if self.schema_search_path == path_string
        self.schema_search_path = path_string
      end

      # # Note: This method has been copied here from Rails 3.2.8
      # # for backwards compatibility with Rails 3.1
      # #
      # # Returns true if schema exists.
      # def schema_exists?(name)
      #   exec_query(<<-SQL, 'SCHEMA', [[nil, name]]).rows.first[0].to_i > 0
      #     SELECT COUNT(*)
      #     FROM pg_namespace
      #     WHERE nspname = $1
      #   SQL
      # end

      # Creates a schema in PostgreSQL
      # @param [#to_s] schema_name declaring the name of the schema
      def create_schema(schema_name)
        ActiveRecord::Base.connection.execute "CREATE SCHEMA \"#{schema_name.to_s}\""
      end

      # Drops a schema and all it's objects (Cascades)
      # @param [#to_s] schema_name declaring the name of the schema to drop
      def drop_schema(schema_name)
        ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS \"#{schema_name.to_s}\" CASCADE")
      end

      def create_schema_dumper(options) # :nodoc:
        Roomer::SchemaDumper.create(self, options)
      end

      # lists the schemas available
      # @return [Array] list of schemas
      def schemas
        ActiveRecord::Base.connection.query(%{
          SELECT nspname FROM pg_namespace WHERE nspname !~ '^pg_.*'
        }).flatten.map(&:to_s)
      end

      # lists all stored procedures for given schema
      # @return [Array] list of stored procedures
      def stored_procedures(schema_name)
        ActiveRecord::Base.connection.select_values(%{
          SELECT  proname
          FROM    pg_catalog.pg_namespace n
          JOIN    pg_catalog.pg_proc p
            ON    pronamespace = n.oid
          WHERE   nspname = '#{schema_name.to_s}'
        })
      end

      # Ensures the schema and schema_migrations exist(creates them otherwise) 
      # and sets current search path to it
      # @param [#to_s] schema_name declaring name to ensure
      # @param [#call] &block code to execute
      #
      def ensuring_schema_and_search_path(schema_name, &block)
        raise ArgumentError.new("schema_name not present") unless schema_name
        ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
        is_shared = schema_name == Roomer.shared_schema_name.to_s
        create_schema(schema_name) unless schemas.include?(schema_name.to_s)
        search_path = is_shared ? "#{schema_name},public" : "#{schema_name}, #{Roomer.shared_schema_name.to_s}, public"
        ActiveRecord::Base.connection.schema_search_path = search_path
        ensure_schema_migrations
        yield
      end

      def ensuring_tenant(tenant,&blk)
        ensuring_schema_and_search_path(tenant.try(Roomer.tenant_schema_name_column)) do
          Roomer.with_tenant(tenant,&blk)
        end
      end

      # Creates sequence for given table name
      # @param [table_name] table for which sequence will be created
      # @param [pk] primary key for table.  Defaults to id
      def create_sequence(table_name, pk="id")
        ActiveRecord::Base.connection.execute(%{
          CREATE SEQUENCE #{table_name}_#{pk}_seq OWNED BY #{table_name}.#{pk}
        })
      end

      # Ensures schema_migrations table exists and creates otherwise
      # @see ActiveRecord::Base.connection#initialize_schema_migrations_table
      def ensure_schema_migrations
        old_search_path = ActiveRecord::Base.connection.schema_search_path
        old_search_path.split(",").each do |search_path|
          ActiveRecord::Base.connection.schema_search_path = search_path
          ActiveRecord::SchemaMigration.create_table

        end
        ActiveRecord::Base.connection.schema_search_path = old_search_path
      end

      # Determine if there are any pending migrations in the shared migrations directory
      # @returns true if migrations are pending
      def shared_migrations_pending?
        ActiveRecord::Migrator.new(:up,Roomer.shared_migrations_directory)
      end

      # Get view definitions for given schema
      # @returns [Array] with all definitions for a given schema
      def view_definitions(schema_name)
        ActiveRecord::Base.connection.select_all(%{
          SELECT definition 
          FROM   pg_views
          WHERE  schemaname = '#{schema_name}';
        })
      end

      def assume_migrated_upto_version(version, migrations_paths)
        migrations_paths = Array(migrations_paths)
        version = version.to_i
        sm_table = quote_table_name(ActiveRecord::SchemaMigration.table_name)

        migrated = ActiveRecord::SchemaMigration.all_versions.map(&:to_i)
        versions = ActiveRecord::MigrationContext.new(migrations_paths).migration_files.map do |file|
          migration_context.parse_migration_filename(file).first.to_i
        end

        unless migrated.include?(version)
          execute "INSERT INTO #{sm_table} (version) VALUES (#{quote(version)})"
        end

        inserting = (versions - migrated).select { |v| v < version }
        if inserting.any?
          if (duplicate = inserting.detect { |v| inserting.count(v) > 1 })
            raise "Duplicate migration #{duplicate}. Please renumber your migrations to resolve the conflict."
          end
          if supports_multi_insert?
            execute insert_versions_sql(inserting)
          else
            inserting.each do |v|
              execute insert_versions_sql(v)
            end
          end
        end
      end

    end
  end
end
