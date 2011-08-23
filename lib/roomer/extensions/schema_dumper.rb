module Roomer
  class SchemaDumper < ActiveRecord::SchemaDumper

    protected
    def header(stream)
      define_params = @version ? ":version => #{@version}" : ""
      stream.puts <<HEADER
# It's strongly recommended to check this file into your version control system.
    
Roomer::Schema.define(#{define_params}) do
HEADER
    end

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
