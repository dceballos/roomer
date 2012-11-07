require "test_helper"

class RoomerTest < ActiveSupport::TestCase

  test 'setup block yeilds self' do
    Roomer.setup do |config|
      assert_equal Roomer, config
    end
  end

  test 'return migrations directory' do
    assert_equal Roomer.tenanted_migrations_directory, "db/migrate"
    Roomer.use_tenanted_migrations_directory = true
    assert_equal Roomer.tenanted_migrations_directory, "db/migrate/tenanted"
  end

  test 'does not allow url_routing_strategy configuration' do
    assert_raise(Roomer::Error) { Roomer.url_routing_strategy = :path   }
    assert_raise(Roomer::Error) { Roomer.url_routing_strategy = :domain }
  end
end
