require 'rails'
require 'active_support/dependencies'

module Roomer
  autoload :Tools, 'roomer/tools'

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

module ActiveRecord
  class Base
    def self.table_name_prefix
      "barson"
    end
  end
end

require 'roomer/rails'
require 'roomer/version'
