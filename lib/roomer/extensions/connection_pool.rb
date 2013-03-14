module Roomer
  module Extensions
    module ConnectionPool
      def self.included(base)
        base.class_eval do
          alias_method :original_checkout, :checkout
          alias_method :original_checkin, :checkin

          # Sets tenanted search each time connection is checked out
          # @returns connection
          def checkout
            conn = original_checkout
            conn.set_roomer_search_path if conn.is_a?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
            conn
          end

          # Resets connection to shared schema when checked in
          # @returns original ConnectionPool#checkin
          def checkin(conn)
            conn.reset_search_path if conn.is_a?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
            original_checkin(conn)
          end
        end
      end
    end
  end
end
