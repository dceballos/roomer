module Roomer
  class RoomerEngine < ::Rails::Engine

    initializer 'roomer.app_controller' do |app|
      ActiveSupport.on_load(:action_controller) do
        include Roomer::ControllerExtensions
        before_filter :ensure_current_tenant
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
