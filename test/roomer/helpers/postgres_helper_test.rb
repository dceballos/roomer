require "test_helper"

class PostgresHelperTest < RoomerTestCase
  include Roomer::Helpers::PostgresHelper

  setup do
    @connection = ActiveRecord::Base.connection
  end

  test 'create schema' do
    assert_nothing_raised { create_schema("test_schema") }
    assert schemas.include? "test_schema"
  end

  test 'drop schema' do
    assert_nothing_raised { create_schema("old_test_schema") }
    assert schemas.include? "old_test_schema"
    assert_nothing_raised { drop_schema("old_test_schema") }
    assert !(schemas.include?("old_test_schema"))
  end

  test 'ensure schema migrations' do
    create_schema("test_schema")
    ensuring_schema_and_search_path(:test_schema) do
      ensure_schema_migrations
      assert @connection.table_exists?(ActiveRecord::Migrator.schema_migrations_table_name) 
    end
  end

  test 'ensure schema and search path' do
    assert_raises(ArgumentError) do
      ensuring_schema_and_search_path {}
    end

    assert_nothing_raised do
      assert !(schemas.include?("new_tenant"))
      ensuring_schema_and_search_path(:new_tenant) do
        assert schemas.include? "new_tenant"
      end
    end
  end

  test 'ensure schema with capital letters in the name' do
    assert_nothing_raised do
      create_schema("Testschema")
      ensuring_schema_and_search_path("Testschema") do
        assert schemas.include? "Testschema"
      end
    end
  end

  test "ensure_tenant sets the current tenant" do
    tenant = tenant_model('foo')
    called = false
    ensuring_tenant(tenant) do
      assert_equal tenant, Roomer.current_tenant
      called = true
    end
    assert called
  end
end
