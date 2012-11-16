include Roomer::Helpers::PostgresHelper
include Roomer::Helpers::GeneratorHelper

namespace :roomer do
  namespace :shared do
    desc "Migrates the shared tables. Target specific version with VERSION=x"
    task :migrate => :environment do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      ensuring_schema(Roomer.shared_schema_name) do
        ActiveRecord::Migrator.migrate(Roomer.shared_migrations_directory, version)
      end
      Roomer::Schema.dump(:shared)
    end

    # copied from https://github.com/rails/rails/blob/master/activerecord/lib/active_record/railties/databases.rake
    task :abort_if_pending_migrations => :environment do
      ensuring_schema(Roomer.shared_schema_name) do
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
      ensuring_schema(Roomer.shared_schema_name) do
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
  end

  namespace :tenanted do
    desc "Migrates the tenanted tables. Target specific version with VERSION=x"
    task :migrate => :environment do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      Roomer.tenant_model.find(:all).each do |tenant|
        ensuring_tenant(tenant) do
          ActiveRecord::Migrator.migrate(Roomer.tenanted_migrations_directory, version)
        end
      end
      Roomer::Schema.dump(:tenanted)
    end

    desc "Rolls back tenanted tables. Target specific version with STEP=x"
    task :rollback => :environment do
      step = ENV['STEP'] ? ENV['STEP'].to_i : 1
      Roomer.tenant_model.find(:all).each do |tenant|
        ensuring_tenant(tenant) do
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
  end

  desc "Runs shared and tenanted migrations"
  task :migrate do
    if ENV["VERSION"].blank?
      Rake::Task["roomer:shared:migrate"].invoke
      Rake::Task["roomer:tenanted:migrate"].invoke
    else
      Rake::Task["roomer:tenanted:migrate"].invoke
      Rake::Task["roomer:shared:migrate"].invoke
    end
  end
end
