Roomer.setup do |config|
  # App Config goes here
  config.tenant_model :<%= model_name %>
  config.shared_schema_name :<%= schema_name %>
end