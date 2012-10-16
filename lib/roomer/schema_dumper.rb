module Roomer
  class SchemaDumper < ActiveRecord::SchemaDumper

    def dump(stream)
      header(stream)
      tables(stream)
      views(stream)
      trailer(stream)
      stream
    end 

    protected
    def header(stream)
      define_params = @version ? ":version => #{@version}" : ""
      stream.puts <<HEADER
# It's strongly recommended to check this file into your version control system.
    
Roomer::Schema.define(#{define_params}) do

HEADER
    end

    def views(stream)
      stream.puts <<VIEWS
  # Database Views
  # The following statements persist database views across tenants

VIEWS
      # Make sure search_path is public so schema name gets dumped 
      # along with table names.
      current_schema = @connection.schema_search_path
      @connection.schema_search_path = "public"
      views = @connection.select_all(%{
        SELECT *
        FROM   pg_views
        WHERE  schemaname = '#{current_schema}';
      })
      # Reinstating previous search path to make sure nothing breaks
      @connection.schema_search_path = current_schema
      unless views.empty?
        views.each do |view|
          stream.puts <<VIEWS
  execute("CREATE OR REPLACE VIEW \#{ActiveRecord::Base.table_name_prefix}#{view['viewname']} AS #{view['definition'].gsub(/#{current_schema}\./, '#{ActiveRecord::Base.table_name_prefix}')}")
VIEWS
        end
      end 
    end

    def roomer_index_name(index_name)
      sections = index_name.split(".")
      if sections.length > 1
        if sections[0].split("_")[0] == "index"
          sections[0] = "index"
        end
      end
      sections.join(".")
    end

    def indexes(table, stream)
      if (indexes = @connection.indexes(table)).any?
        add_index_statements = indexes.map do |index|
          statement_parts = [ ('add_index ' + index.table.inspect) ]
          statement_parts << index.columns.inspect
          statement_parts << (':name => "' + roomer_index_name(index.name) + '"')
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
