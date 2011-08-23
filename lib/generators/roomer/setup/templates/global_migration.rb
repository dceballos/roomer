# Migration for the Roomer.tenants_table
class RoomerCreate<%= Roomer.tenants_table.to_s.camelize %> < ActiveRecord::Migration
  def self.up
    create_table(:<%= Roomer.tenants_table %>) do |t|
      t.string :<%= Roomer.tenant_url_identifier_column %>
      t.string :<%= Roomer.tenant_schema_name_column %>

      # Add additional columns here
      # t.string :name
      t.timestamps
    end

    add_index :<%= Roomer.tenants_table %>, :<%= Roomer.tenant_url_identifier_column %>, :unique => true
    add_index :<%= Roomer.tenants_table %>, :<%= Roomer.tenant_schema_name_column %>, :unique => true
  end

  def self.down
    remove_index :<%= Roomer.tenants_table %>, :<%= Roomer.tenant_url_identifier_column %>
    remove_index :<%= Roomer.tenants_table %>, :<%= Roomer.tenant_schema_name_column %>
    drop_table :<%= Roomer.tenants_table %>
  end
end
