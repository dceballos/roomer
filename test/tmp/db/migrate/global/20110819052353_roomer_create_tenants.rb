# Migration for the Roomer.tenants_table
class RoomerCreateTenants < ActiveRecord::Migration
  def self.up
    create_table(:tenants) do |t|
      t.string :url_identifier
      t.string :schema_name

      # Add additional columns here
      # t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :tenants
  end
end
