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
    tenant1 = mock()
    tenant2 = mock()

    assert_not_equal(tenant1,tenant2)

    thread1 = Thread.new do
      Roomer.current_tenant = tenant1
      sleep 1
      assert_equal(Roomer.current_tenant,tenant1)
    end

    thread2 = Thread.new do
      Roomer.current_tenant = tenant2
      assert_equal(Roomer.current_tenant,tenant2)
    end

    thread2.join
  end
end
