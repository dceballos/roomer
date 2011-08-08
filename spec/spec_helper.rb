require 'rubygems'
require 'bundler/setup'


RSpec.configure do |config|
  config.mock_with :rr
  config.before(:each) do
    Project.delete_all
    Category.delete_all
  end
end