class RoomerCreate<%= table_name.camelcase %> < ActiveRecord::Migration
  def self.up
    create_table(:<%= table_name %>) do |t|
      t.string :domain_name
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
