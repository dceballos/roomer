# FIXME Remove Postgres Server Hard dependency

ENV["RAILS_ENV"] = "test"

require "roomer"
require "rails_app/config/environment"
require "rails/test_help"

# For generators
require "rails/generators/test_case"
