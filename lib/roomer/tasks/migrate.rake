include Roomer::Helpers::PostgresHelper
include Roomer::Helpers::GeneratorHelper
include Roomer::Helpers::MigrationHelper

namespace :roomer do
  namespace :shared do
    desc "Migrates the shared tables. Target specific version with VERSION=x"
    task :migrate => :environment do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      ensuring_schema_and_search_path(Roomer.shared_schema_name) do
        ActiveRecord::Migrator.migrate(Roomer.shared_migrations_directory, version)
      end
      Roomer::Schema.dump(:shared)
    end

    # copied from https://github.com/rails/rails/blob/master/activerecord/lib/active_record/railties/databases.rake
    task :abort_if_pending_migrations => :environment do
      ensuring_schema_and_search_path(Roomer.shared_schema_name) do
        pending_migrations = ActiveRecord::Migrator.new(:up, Roomer.shared_migrations_directory).pending_migrations
        if pending_migrations.any?
          puts "You have #{pending_migrations.size} pending migrations:"
          pending_migrations.each do |pending_migration|
            puts '  %4d %s' % [pending_migration.version, pending_migration.name]
          end
          abort %{Run "rake roomer:migrate" to update your shared schema, then try again.}
        end
      end
    end

    desc "Rolls back shared tables. Target specific version with STEP=x"
    task :rollback => :environment do
      step = ENV['STEP'] ? ENV['STEP'].to_i : 1
      ensuring_schema_and_search_path(Roomer.shared_schema_name) do
        ActiveRecord::Migrator.rollback(Roomer.shared_migrations_directory, step)
      end
      Roomer::Schema.dump(:shared)
    end

    namespace :schema do
      desc "Load shared schema into database"
      task :load => :environment do
        Roomer::Schema.load(Roomer.shared_schema_name, :shared)
      end

      desc "Dumps the shared schema to shared/schema.rb.  This file can be portably used against any DB supported by AR"
      task :dump => :environment do
        Roomer::Schema.dump(:shared)
      end
    end

    desc "Display status of migrations for shared schema"
    task :status => :environment do
      ensuring_schema_and_search_path(Roomer.shared_schema_name) do
        status(Roomer.shared_schema_name,Roomer.shared_migrations_directory)
     end
   end

  end

  namespace :tenanted do
    desc "Migrates the tenanted tables. Target specific version with VERSION=x"
    task :migrate => :environment do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      Roomer.tenant_model.all.each do |tenant|
        ensuring_tenant(tenant) do
          ActiveRecord::Migrator.migrate(Roomer.tenanted_migrations_directory, version)
        end
      end
      Roomer::Schema.dump(:tenanted)
    end

    desc "Updates tenanted SQL Views."
    task :sqlviews => :environment do      
      Roomer.tenant_model.all.each do |tenant|
        ensuring_tenant(tenant) do
          Dir["#{Rails.root}/db/sqlviews/tenanted/*.sql"].each do |file|
            fd = File.new(file, 'r')
            sqlView = fd.read
            if fd and sqlView
              ActiveRecord::Base.transaction do
                sqlTrans = sqlView.split(/;[ \t]*$/)
                if sqlTrans.respond_to?(:each)
                  sqlTrans.each do |transaction|
                    ActiveRecord::Base.connection.execute "#{transaction};"
                  end
                end
              end  
            end
          end  
        end
      end
    end

    desc "Rolls back tenanted tables. Target specific version with STEP=x"
    task :rollback => :environment do
      step = ENV['STEP'] ? ENV['STEP'].to_i : 1
      Roomer.tenant_model.all.each do |tenant|
        ensuring_tenant(tenant) do
          ActiveRecord::Base.connection.schema_search_path = "#{tenant.schema_name},#{Roomer.shared_schema_name}"
          ActiveRecord::Migrator.rollback(Roomer.tenanted_migrations_directory, step)
        end
      end
      Roomer::Schema.dump(:tenanted)
    end

    namespace :schema do
      desc "Load tenanted schema into database"
      task :load => :environment do
        schema_name = ENV['SCHEMA_NAME']
        raise "No schema name provided.  Try: env SCHEMA_NAME=" if schema_name.blank?
        Roomer::Schema.load(schema_name)
      end

      desc "Dumps tenanted schema file to migrate/schema.rb.  This file can be portably used against any DB supported by AR"
      task :dump => :environment do
        Roomer::Schema.dump
      end
    end

    desc "Display status of migrations for tenanted schema"
    task :status do
      Roomer.tenant_model.all.each do |tenant|
        ensuring_tenant(tenant) do
          ensuring_schema_and_search_path(Roomer.current_tenant.schema_name) do
            status(Roomer.current_tenant.schema_name,Roomer.tenanted_migrations_directory)
          end
        end
      end
    end

  end

  desc "Updates SQL Views"
  task :sqlviews do
    Rake::Task["roomer:tenanted:sqlviews"].invoke
  end  
  
  desc "Runs shared and tenanted migrations"
  task :migrate do
    byebug
    if ENV["VERSION"].blank?
      Rake::Task["roomer:shared:migrate"].invoke
      Rake::Task["roomer:tenanted:migrate"].invoke
      Rake::Task["roomer:tenanted:sqlviews"].invoke
    else
      Rake::Task["roomer:tenanted:migrate"].invoke
      Rake::Task["roomer:tenanted:sqlviews"].invoke
      Rake::Task["roomer:shared:migrate"].invoke
    end
  end

namespace :migrate do

desc "'Display status of migrations "

  task :status do
    Rake::Task["roomer:shared:status"].invoke
    Rake::Task["roomer:tenanted:status"].invoke
  end
end

end
