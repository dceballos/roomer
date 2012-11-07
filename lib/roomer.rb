require 'rails'
require 'active_support'
require 'active_support/dependencies'
require 'active_record'
require 'roomer/version'

module ActiveRecord
  autoload :Migration,          'active_record/migration'
end

module Roomer
  autoload :Utils,              'roomer/utils'
  autoload :Middleware,         'roomer/middleware'

  module Helpers
    autoload :GeneratorHelper,  'roomer/helpers/generator_helper'
    autoload :PostgresHelper,   'roomer/helpers/postgres_helper'
    autoload :MigrationHelper,  'roomer/helpers/migration_helper'
  end

  module Extensions
    autoload :Model,            'roomer/extensions/model'
    autoload :Controller,       'roomer/extensions/controller'
  end

  autoload :SchemaDumper,       'roomer/schema_dumper'
  autoload :Schema,             'roomer/schema'

  class Error < StandardError
  end

  extend Utils

  # The URL routing strategy. Roomer currently supports one routing strategy (:domain)
  #  * :domain  -  Using domain name to identify the tenant. This could include a subdomain
  #  Example:
  #  Domain
  #  ------
  #  http://mytenant.myapp.com - If you tenant has a subdomain under your domain
  #  http://mytenant.com - If the tenant choose to use their own top level domain name
  #  http://myapp.mytenant.com If the tenant chooses to use their own subdomain under thier TLD
  mattr_reader :url_routing_strategy
  @@url_routing_strategy = :domain
  def self.url_routing_strategy= strategy
    raise Roomer::Error, "Only domain routing strategy supported"
  end

  # name of the shared schema where all the shared tables are be present
  mattr_accessor :shared_schema_name
  @@shared_schema_name = :global

  # The name of the table where the tenants are stored, this table must 
  # contain two required columns configured under tenant_url_identifier_column and
  # tenant_schema_name_column
  mattr_accessor :tenants_table
  @@tenants_table = :tenants

  # The column name that stores the url identfier in the tenants tables.
  # A url idenfier is a unique value that identifies the tenant from the URL.
  # For e.g: if you use domains and the url is http://mytenant.myapp.com, 
  # the url identifier would "mytenant"
  mattr_accessor :tenant_url_identifier_column
  @@tenant_url_identifier_column = :url_identifier

  # The column name that strores the schema name in the tenants tables. 
  mattr_accessor :tenant_schema_name_column
  @@tenant_schema_name_column = :schema_name

  # The schema seperator. This is used when generating the table name. 
  # The default is set to "."
  # Example: tenant's table by default will be global.tenants
  mattr_accessor :schema_seperator
  @@schema_seperator = '.'

  # Directory where schema files will be stored.
  mattr_accessor :schemas_directory
  @@schemas_directory = File.expand_path(File.join("db", "schemas"))

  # Tenanted schema filename.
  mattr_accessor :tenanted_schema_filename
  @@tenanted_schema_filename = "tenanted_schema.rb"

  # Shared schema filename.
  mattr_accessor :shared_schema_filename
  @@shared_schema_filename = "shared_schema.rb"

  # Use Tentant migrations directory?
  # Default is set to false 
  mattr_accessor :use_tenanted_migrations_directory
  alias_method   :use_tenanted_migrations_directory?,
                 :use_tenanted_migrations_directory 
  @@use_tenanted_migrations_directory = false

  # Directory where the tenanted migrations are stored.
  # This will be used only if use_tenanted_migration_directory is set to
  # true if not usual rails migraiton directory db/migrate will be used
  mattr_writer :tenanted_migrations_directory
  @@tenanted_migrations_directory = File.join(migrations_directory, "tenanted")


  # Directory where shared migrations are stored.
  mattr_accessor :shared_migrations_directory
  @@shared_migrations_directory = File.join(migrations_directory,shared_schema_name.to_s)

  # When set to true will not dump schema files
  mattr_accessor :heroku_safe
  @@heroku_safe = true

  # Set to true for automatic inclusion
  # of Roomer::Middleware in the app's middleware
  # stack
  mattr_accessor :install_middleware
  @@install_middleware = true

  # Set to true for automatic inclusion
  # of Roomer::Extensions::Controller in
  # Application::Controller
  mattr_accessor :install_controller_extensions
  @@install_controller_extensions = false

  # Fetches the migrations directory for Tenanted migrations. 
  # returns the standard rails migration directory "db/migrate" is the 
  # use_tenanted_migrations_directory is set to false
  # @return [String] String representing the tenanted migrations
  def self.tenanted_migrations_directory
    if self.use_tenanted_migrations_directory
      return @@tenanted_migrations_directory
    end
    return migrations_directory
  end

  # Default way to setup Roomer. Run rails generate roomer:install to create
  # a fresh initializer with all configuration values.
  # @example
  #     Roomer.setup do |config|
  #       config.url_routing_strategy = :domain
  #     end
  def self.setup
    yield self
  end

end

require 'roomer/rails'
