module Roomer
  module Helpers
    module ModelHelper
      include GeneratorHelper
      
      # Check to see if the model file exists, should be used in a Generator
      # @return [True,False] 
      def model_exists?
        File.exists?(File.join(destination_root, model_path))
      end

      # Returns the path of the model
      # @return [String] model_path string representing the model location
      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end
      
      # Checks if roomer is configured for the model
      # @return [True,False]
      def roomer_model?(model_name)
        modelify(model_name.to_s).send(:shared?) || modelify(model_name.to_s).send(:tenanted?)
      end
      
      # Constantizes a String
      # @param [String] model_name String representing the model name
      # @return [Constant]
      def modelify(model_name)
        model_name.classify.constantize
      end
      
      def shared?
        @shared ||= options[:shared]
      end
      
      def migration_dir
        return Roomer.shared_migrations_directory if shared?
        return Roomer.tenanted_migrations_directory
      end
      
    end
  end
end