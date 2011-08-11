# Be sure to restart your server when you modify this file.
Roomer.setup do |config|
  
  # ==> URL Routing Strategy
  # Configure the URL routing strategy. Roomer currently supports two routing strategies
  # :domain   : Using domain name to identify the tenant. This could include a subdomain
  #             e.g. http://mytenant.myapp.com - If you tenant has a subdomain 
  #             under your domain
  #             http://mytenant.com - If the tenant choose to use their 
  #             own top level domain name
  #             http://myapp.mytenant.com - If the tenant chooses to use their 
  #             own subdomain under thier TLD
  # :path     : Identifying the tenant by the path
  #             e.g. http://yourapp.com/tenant
  # Default is :domain
  # config.url_routing_strategy = :subdomain
  
  # ==> Data Settings (Advanced)
  # IMPORTANT: Modifying these settings after you ran "rails generate roomer:setup" 
  # will require you to make manual changes in the database. Proceed with caution.
  
  # Configure the name of the shared schema, this is where all the shared 
  # tables are be present. The default is :global
  # config.shared_schema_name = :shared_schema_name
  
  # Configure the name of the table where the tenants are stored, this table must 
  # contain two required columns configured under:
  #     config.tenant_url_identifier_column
  #     config.tenant_schema_name_column
  # The default value is :tenants
  # config.tenants_table = :tenants
  
  # Configure the column name that strores the schema name in the tenants tables. 
  # The default value is :schema_name
  # config.tenant_schema_name_column = :schema_name
  
  # Configure the column name that strores the url identfier in the tenants tables.
  # A url idenfier is a unique value that identifies the tenant from the URL.
  # For e.g: if you use subdomains and the url is http://mytenant.myapp.com, 
  # the url identifier would "mytenant"
  # The default value is :url_identifier
  # config.tenant_url_identifier_column = :url_identifier
  
  # Configure the schema seperator. This is used when generating the table name. 
  # The default is set to ".". for e.g., tenant's table by default will be global.tenants
  # config.schema_seperator = "."
  
  # Directory where shared migrations are stored. Please make
  # sure your migrations are present in this directory.
  config.shared_migrations_directory = "db/migrations/#{Roomer.shared_schema_name}"
  
  # Directory where tenanted migrations are stored. Please make
  # sure your migrations are present in this directory.
  config.tenanted_migrations_directory = "db/migrations/#{Roomer.tenants_table}"
  
end