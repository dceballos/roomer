require "test_helper"
require "generators/roomer/migration/migration_generator"

class MigrationGeneratorTest < Rails::Generators::TestCase
  tests Roomer::Generators::MigrationGenerator 
  destination File.expand_path("../../tmp", __FILE__)
  
  def setup 
    prepare_destination
    @use_teananted_migrations = Roomer.use_tenanted_migrations_directory
  end
  
  def teardown
    Roomer.use_tenanted_migrations_directory = @use_teananted_migrations
  end
  
  test "create migration for a tenanted model" do
    Roomer.use_tenanted_migrations_directory = false
    run_generator %w(add_tenant_bar_to_foos bar:string)
    assert_migration "db/migrate/roomer_add_tenant_bar_to_foos.rb"
  end

  test "create migration for a tenanted model in tenant dir" do
    Roomer.use_tenanted_migrations_directory = true
    run_generator %w(add_tenant_bar_to_foos bar:string)
    assert_migration "db/migrate/tenanted/roomer_add_tenant_bar_to_foos.rb"
  end

  test "create migration for shared model" do
    run_generator %w(add_bar_to_foos bar:string --shared)
    assert_migration "db/migrate/global/roomer_add_bar_to_foos.rb"
  end  
end
