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
  end

  def self.down
    drop_table :<%= Roomer.tenants_table %>
  end
end
