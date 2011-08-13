include Roomer::Helpers::PostgresHelper

namespace :roomer do
  namespace :shared do    
    desc "Migrates the shared tables. Target specific version with VERSION=x"
    task :migrate => :environment do
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      ensuring_schema(Roomer.shared_schema_name) do
        ActiveRecord::Migrator.migrate(Roomer.full_shared_shema_migration_path, version)
      end
    end
    
    desc "Rolls back shared tables. Target specific version with STEP=x"
    task :rollback => :environment do
      step = ENV['STEP'] ? ENV['STEP'].to_i : 1
      ensuring_schema(Roomer.shared_schema_name) do
        ActiveRecord::Migrator.rollback(Roomer.full_shared_shema_migration_path, step)
      end
    end  
  end
  
  namespace :tentanted do
    desc "Migrates the tenanted tables. Target specific version with VERSION=x"
    task :migrate => :environment do
    end
  end
  
end