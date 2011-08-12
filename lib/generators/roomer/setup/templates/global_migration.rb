# Migration for the Roomer.tenants_table
class RoomerCreate<%= Roomer.tenants_table.to_s.camelize %> < ActiveRecord::Migration
  def self.up
    create_table(:<%= Roomer.tenants_table %>) do |t|
      t.string :name
      t.string :url_identifier
      t.string :namespace
      t.timestamps
    end
  end

  def self.down
    drop_table :<%= Roomer.tenants_table %>
  end
end
