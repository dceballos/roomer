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
    assert_equal Roomer.tenanted_migrations_directory, "db/migrate/tenants"
  end


  test 'set the current tenant' do
    tenant = mock()
    Roomer.current_tenant = tenant
    assert_equal(Roomer.current_tenant,tenant) 
  end
end
