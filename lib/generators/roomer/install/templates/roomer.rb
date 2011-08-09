Roomer.setup do |config|
   # Name of the tenant model
  config.tenant_model_name  = :<%= model_name %>
  
  # Name of the shared schema
  config.shared_schema_name = :<%= schema_name %>
end