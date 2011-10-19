module Roomer
  class RoomerEngine < ::Rails::Engine

    initializer 'roomer.extensions' do |app|
      # load model extensions
      ActiveSupport.on_load(:active_record) do
        include Roomer::Extensions::Model
        ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(:include, Roomer::Helpers::PostgresHelper)
      end

      # load controller extensions
      ActiveSupport.on_load(:action_controller) do
        include Roomer::Extensions::Controller
      end
    end

    # load all the rake tasks
    rake_tasks do
      Dir[File.expand_path("../tasks/*.rake", __FILE__)].each do |file|
        load file
      end
    end

  end
end
