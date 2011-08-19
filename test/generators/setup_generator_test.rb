require "test_helper"
require "generators/roomer/setup/setup_generator"

class SetupGeneratorTest < Rails::Generators::TestCase
  tests Roomer::Generators::SetupGenerator
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination

  test "Assert roomer method exists in Tenant model" do
    run_generator
    assert_file "app/models/tenant.rb" do |model|
      assert_match /roomer :shared/, model
    end
  end

  test "Assert migration file exist and contains need attributes" do
    run_generator
    assert_migration "db/migrate/global/roomer_create_tenants.rb" do |migration|
      assert_match /t.string :url_identifier/, migration
      assert_match /t.string :schema_name/,    migration
    end
  end


end
