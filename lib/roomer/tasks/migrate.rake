namespace :db do
  desc "Migrate the database through scripts in db/migrate to do migration files under db/migrate/*. Target specific version with VERSION=x"
  
  task :mytask => :environment do
    Roomer::Tools.create_shared_schema
    Roomer::Tools.set_search_path(Roomer.shared_schema_name.to_s)
    
    ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    ActiveRecord::Migrator.migrate(shared_shema_migration_path, version)
  end
  
  task :myrollback => :environment do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback(shared_shema_migration_path, step)
  end
  
  def shared_shema_migration_path
    @shared_shema_migration_path ||= File.join(Rails.root,"db","migrate",Roomer.shared_schema_name.to_s)
  end
  

end