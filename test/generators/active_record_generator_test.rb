require "test_helper"
require "generators/active_record/roomer_generator"

class ActiveRecordGeneratorTest < Rails::Generators::TestCase
  tests ActiveRecord::Generators::RoomerGenerator
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination

  test "create class and migration for a tenanted model" do
    run_generator %w(foo bar:string)
    assert_file "app/models/foo.rb" do |model|
      assert_match /roomer :tenanted/, model
    end
    assert_migration "db/migrate/roomer_create_foos.rb"
  end

  test "create class and migration for shared model" do
    run_generator %w(foo bar:string --shared)
    assert_file "app/models/foo.rb" do |model|
      assert_match /roomer :shared/, model
    end
  end

end
