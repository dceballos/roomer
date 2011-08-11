class RoomerCreate<%= table_name.camelcase %> < ActiveRecord::Migration
  def self.up
    create_table(:<%= table_name %>) do |t|
      t.string :name
      t.string :url_identifier
      t.string :namespace
      t.timestamps
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
