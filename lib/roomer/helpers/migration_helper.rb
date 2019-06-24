module Roomer
  module Helpers
    module MigrationHelper
      # Migration Helper Methods go here

      # copied from https://github.com/rails/rails/blob/master/activerecord/lib/active_record/railties/databases.rake
      def status(schema_name,migrations_directory)
        db_list = ActiveRecord::Base.connection.select_values("SELECT version FROM #{ActiveRecord::SchemaMigration.table_name}")
        db_list.map! { |version| "%.3d" % version }
        file_list = []
        Dir.foreach(migrations_directory) do |file|
          if match_data = /^(\d{3,})_(.+)\.rb$/.match(file)
            status = db_list.delete(match_data[1]) ? 'up' : 'down'
            file_list << [status, match_data[1], match_data[2].humanize]
          end
        end
        db_list.map! do |version|
          ['up', version, '********** NO FILE **********']
        end
        # output
        puts "\ndatabase: #{ActiveRecord::Base.connection_config[:database]}"
        puts "\nschema: #{schema_name}\n\n"
        puts "#{'Status'.center(8)}  #{'Migration ID'.ljust(14)}  Migration Name"
        puts "-" * 50
        (db_list + file_list).sort_by {|migration| migration[1]}.each do |migration|
          puts "#{migration[0].center(8)}  #{migration[1].ljust(14)}  #{migration[2]}"
        end
        puts
      end

    end
  end
end
