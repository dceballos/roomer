ENV["RAILS_ENV"] = "test"
require "rails_app/config/environment"
require "rails/test_help"

#require 'mocha'
#require 'webrat'
#Webrat.configure do |config|
#  config.mode = :rails
#  config.open_error_files = false
#end

# Add support to load paths so we can overwrite broken webrat setup
#$:.unshift File.expand_path('../support', __FILE__)
#Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# For generators
require "rails/generators/test_case"
