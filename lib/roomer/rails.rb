module Roomer
  class Engine < ::Rails::Engine
    
    # load all the rake tasks
    rake_tasks do
      Dir[File.expand_path("../tasks/*.rake", __FILE__)].each do |file| 
        load file
      end
    end
  end
end