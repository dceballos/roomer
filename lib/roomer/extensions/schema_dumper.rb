module Roomer
  class SchemaDumper < ActiveRecord::SchemaDumper

    def header(stream)
      define_params = @version ? ":version => #{@version}" : ""
      stream.puts <<HEADER
# This file is auto-generated from the current state of the database. Instead                                     # of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.                                 #
# Note that this schema.rb definition is the authoritative source for your 
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.
    
Roomer::Schema.define(#{define_params}) do
HEADER
    end

    protected
    def indexes(table, stream)
      if (indexes = @connection.indexes(table)).any?
        add_index_statements = indexes.map do |index|
          statement_parts = [ ('add_index ' + index.table.inspect) ]
          statement_parts << index.columns.inspect
          statement_parts << (':name => "' + index.columns.first.to_s.split('.').last + '"')
          statement_parts << ':unique => true' if index.unique
  
          index_lengths = index.lengths.compact if index.lengths.is_a?(Array)
          if index_lengths.present?
            statement_parts << (':length => ' + Hash[*index.columns.zip(index.lengths).flatten].inspect)
          end
  
          '  ' + statement_parts.join(', ')
        end
  
        stream.puts add_index_statements.sort.join("\n")
        stream.puts
      end
    end
  end
end
