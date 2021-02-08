class Roomer::Middleware
  def initialize(app)
    @app = app
  end
  def call(env)
    Roomer.with_tenant_from_request(Rack::Request.new(env)) do |tenant|
      env["roomer.tenant"] = tenant
      @app.call(env)
    end
  rescue Roomer::Error
    respond_with_error
  end
  
  def respond_with_error
    [406, {"Content-Type" => "text/plain"}, ["Not Acceptable"]]
  end
end
