require 'test_helper'

class RoomerUtilsTest < RoomerTestCase
  test 'identifier_from_request uses the host when routing strategy is domain' do
    assert_equal 'unknown', Roomer.identifier_from_request(request('unknown'))
  end
  test 'tenant_from_request should raise an error if the tenant does not exist' do
    assert_raise(Roomer::Error) do
      Roomer.tenant_from_request(request('unknown'))
    end
  end
  test 'tenant_from_request should find a tenant by host' do
    tenant = tenant_model('foo')
    assert_equal tenant, Roomer.tenant_from_request(request(tenant.url_identifier))
  end
  test 'with_tenant_from_request should set the current tenant' do
    tenant = tenant_model('foo')
    Roomer.current_tenant = nil
    Roomer.with_tenant_from_request(request(tenant.url_identifier)) do
      assert_equal(tenant,Roomer.current_tenant)
    end
    assert_nil Roomer.current_tenant
  end
  test 'with_tenant_from_request should yield the current tenant' do
    tenant = tenant_model('foo')
    Roomer.with_tenant_from_request(request(tenant.url_identifier)) do |current|
      assert_equal(tenant,Roomer.current_tenant)
      assert_equal(tenant,current)
    end
  end
  test 'with_tenant should set the current when there is no current tenant' do
    tenant = tenant_model('foo')
    Roomer.current_tenant = nil
    Roomer.with_tenant(tenant) do
      assert_equal(tenant,Roomer.current_tenant)
    end
    assert_nil Roomer.current_tenant
  end
  test 'with_tenant should set the current when there is a current tenant' do
    current = tenant_model('orig')
    tenant  = tenant_model('foo')
    Roomer.current_tenant = current
    Roomer.with_tenant(tenant) do
      assert_equal(tenant,Roomer.current_tenant)
    end
    assert_equal current, Roomer.current_tenant
  end
  test 'with_tenant should yield the current tenant' do
    tenant = tenant_model('foo')

    Roomer.with_tenant(tenant) do |current|
      assert_equal(tenant,Roomer.current_tenant)
      assert_equal(tenant,current)
    end
  end
end
