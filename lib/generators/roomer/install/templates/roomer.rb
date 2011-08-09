Roomer.setup do |config|
  # App Config goes here
  config.tenant_model :<%= options[:model_name].to_s.downcase %>
  config.global_schema_name :<%= options[:schema_name].to_s.downcase %>
end