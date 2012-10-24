# FIXME Remove Postgres Server Hard dependency

ENV["RAILS_ENV"] = "test"

require "roomer"
require "rails_app/config/environment"
require "rails/test_help"

# For generators
require "rails/generators/test_case"

class RoomerTestCase < ActiveSupport::TestCase
  def request(host)
    Rack::Request.new({'HTTP_HOST' => host})
  end
  def tenant_model(name)
    Roomer.tenant_model.find_or_create_by_url_identifier(name,:schema_name => name)
  end
end
