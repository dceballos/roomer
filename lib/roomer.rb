require 'rails'
require 'active_support/dependencies'
require 'roomer/version'

module Roomer
  autoload :Tools, 'roomer/tools'
  
  # The URL routing strategy. Roomer currently supports two routing strategies (:domain and :path)
  #  * :domain  -  Using domain name to identify the tenant. This could include a subdomain
  #  * :path    -  identifying the tenant by the path
  #  Example:
  #  Domain
  #  ------
  #  http://mytenant.myapp.com - If you tenant has a subdomain under your domain
  #  http://mytenant.com - If the tenant choose to use their own top level domain name
  #  http://myapp.mytenant.com If the tenant chooses to use their own subdomain under thier TLD
  #  Path
  #  ----
  #  http://yourapp.com/tenant
  mattr_accessor :url_routing_strategy
  @@url_routing_strategy = :domain
  
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
  
  # Rails DB Migrations Directory
  # @return [String] full path to the migrations directory
  def self.migrations_directory
    File.join("db","migrate")
  end
  
  # Directory where shared migrations are stored.
  mattr_accessor :shared_migrations_directory
  @@shared_migrations_directory = File.join(migrations_directory,shared_schema_name.to_s)
  
  # Directory where the tenanted migrations are stored.
  mattr_accessor :tenanted_migrations_directory
  @@tenanted_migrations_directory = File.join(migrations_directory,tenants_table.to_s)
  
  # Consutructs the full name for the tenants table with schema 
  # Example: 'global.tenant'
  # @return [String] full name of the tenant table
  def self.full_tenants_table_name
    "#{shared_schema_name}#{schema_seperator}#{tenants_table}"
  end
  
  # Constructs the full path to the shared schema directory
  # Example: /Users/Greg/Projects/roomer/db/migrate/global  
  # @return [String] full path to the shared schema directory
  def self.full_shared_shema_migration_path
    "#{Rails.root}/#{shared_migrations_directory}"
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

require 'roomer/extensions/active_record'
require 'roomer/rails'




