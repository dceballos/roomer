class Roomer::Middleware
  def initialize(app)
    @app = app
  end
  def call(env)
    Roomer.with_tenant_from_request(Rack::Request.new(env)) do |tenant|
      env["roomer.tenant"] = tenant
      @app.call(env)
    end
  end
end
