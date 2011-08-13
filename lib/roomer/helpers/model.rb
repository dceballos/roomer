module Roomer
  module Helpers
    module ModelHelper
      def model_exists?
        File.exists?(File.join(destination_root, model_path))
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end
      
      def roomer_exists?(model)
        modelify(model).send(:shared?) || modelify(model).send(:tenanted?)
      end
      
      def modelify(model)
        model.classify.constantize
      end
      
      def error_out_and_exit(message)
        # color = Thor::Shell::Color.new
        # color.set_color(message,Thor::Shell::Color::RED,true)
        puts message
        exit
      end
      
      def info_message(message)
        # color = Thor::Shell::Color.new
        # color.set_color(message,Thor::Shell::Color::BLUE,true)
        puts message
      end
      
    end
  end
end