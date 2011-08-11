require 'rails'
require 'active_support/dependencies'
require 'roomer/version'

module Roomer
  autoload :Tools, 'roomer/tools'
  
  # @attribute
  # The URL routing strategy. Roomer currently supports two routing strategies
  # :domain   : Using domain name to identify the tenant. This could include a subdomain
  #             e.g. http://mytenant.myapp.com - If you tenant has a subdomain 
  #             under your domain
  #             http://mytenant.com - If the tenant choose to use their 
  #             own top level domain name
  #             http://myapp.mytenant.com - If the tenant chooses to use their 
  #             own subdomain under thier TLD
  # :path     : Identifying the tenant by the path
  #             e.g. http://yourapp.com/tenant
  mattr_accessor :url_routing_strategy
  @@url_routing_strategy = :domain
  
  
  # @attribute
  # The name of the table where the tenants are stored, this table must 
  # contain two required columns configured under:
  # @see #tenant_url_identifier_column
  # @see #tenant_schema_name_column
  mattr_accessor :tenants_table
  @@tenant_model_name = :tenant
  
  # The name of the shared schema, this is where all the shared 
  # tables are be present
  mattr_accessor :shared_schema_name
  @@shared_schema_name = :global
  
  # The column name that stores the url identfier in the tenants tables.
  # A url idenfier is a unique value that identifies the tenant from the URL.
  # For e.g: if you use domains and the url is http://mytenant.myapp.com, 
  # the url identifier would "mytenant"
  mattr_accessor :tenant_url_identifier_column
  @@tenant_url_identifier_column = :url_identifier
  
  mattr_accessor :tenant_schema_name_column
  @@tenant_schema_name_column = :schema_name
  
  # The schema seperator. This is used when generating the table name. 
  # The default is set to ".". for e.g., tenant's table by default will 
  # be global.tenants
  mattr_accessor :schema_seperator
  @@schema_seperator = '.'
  
  mattr_accessor :shared_migrations_directory
  @shared_migrations_directory = "db/migrations/#{shared_schema_name}"
  
  mattr_accessor :tenanted_migrations_directory
  @tenanted_migrations_directory = "db/migrations/#{tenants_table}"
  
  def self.full_tenants_table_name
    "#{shared_schema_name}#{schema_seperator}#{tenants_table}"
  end
  
  def self.setup
    yield self
  end
end


require 'roomer/extensions/active_record'
require 'roomer/rails'
require 'roomer/version'



