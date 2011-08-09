namespace :roomer do
  
  namespace :db do
    
    desc "Migrate the database through scripts in db/migrate to do migration files under db/migrate/*. Target specific version with VERSION=x"
    task :migrate => :environment do
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      # creates the shared schema if it doesn't exist
      Roomer::Tools.create_schema(Roomer.shared_schema_name.to_s)
      Roomer::Tools.set_search_path(Roomer.shared_schema_name.to_s)
      version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
      ActiveRecord::Migrator.migrate(shared_shema_migration_path, version)
    end
    
    desc "Rolls back database"
    task :rollback => :environment do
      Roomer::Tools.set_search_path(Roomer.shared_schema_name.to_s)
      step = ENV['STEP'] ? ENV['STEP'].to_i : 1
      ActiveRecord::Migrator.rollback(shared_shema_migration_path, step)
    end
  end
  
  def shared_shema_migration_path
    @shared_shema_migration_path ||= File.join(Rails.root,"db","migrate",Roomer.shared_schema_name.to_s)
  end

end