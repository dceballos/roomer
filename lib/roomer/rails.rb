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

        # XXX: only here for backwards-compatibility.
        #      users should just do this by hand.

        if Roomer.install_middleware
          if defined?(ActionDispatch::BestStandardsSupport)
            app.middleware.insert_after(ActionDispatch::BestStandardsSupport, Roomer::Middleware)
          else
            app.middleware.use(Roomer::Middleware)
          end
        end

        if Roomer.install_controller_extensions
          include Roomer::Extensions::Controller
        end

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
