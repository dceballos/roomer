require 'test_helper'
class MiddlewareTest < RoomerTestCase
  def env(host)
    {'HTTP_HOST' => host}
  end
  test "should set the current tenant" do
    tenant = tenant_model('foo')
    app    = Proc.new do |env|
      assert_equal(tenant,env["roomer.tenant"])
      assert_equal(tenant,Roomer.current_tenant)
    end
    middleware = Roomer::Middleware.new(app)
    middleware.call(env(tenant.url_identifier))
    assert_nil(Roomer.current_tenant)
  end
  test "should require a tenant" do
    middleware = Roomer::Middleware.new("")
    assert_raise(Roomer::Error) do
      middleware.call(env('none'))
    end
  end
end
