require 'rails'
require 'active_support/dependencies'
require "roomer/version"

module Roomer
  
  # Name of the tenant model
  mattr_accessor :tenant_model_name
  @@tenant_model_name = :tenant
  
  # Name of the shared schema
  mattr_accessor :shared_schema_name
  @@shared_schema_name = :global
  
  def self.setup
    yield self
  end
end
