class RoomerCreate<%= options[:model_name].to_s.camelize %> < ActiveRecord::Migration
  def self.up
    create_table(:<%= options[:model_name].to_s.downcase.pluralize %>) do |t|
      t.string :domain_name
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :<%= options[:model_name].to_s.downcase.pluralize %>
  end
end
