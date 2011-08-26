module Roomer
  module Helpers
    module ModelHelper

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

      # Reads the --shared option specified when running "rails generate roomer:model"
      # @return [True,False]
      def shared?
        @shared ||= options[:shared]
      end

      # Fetchs the migration directory for the migrations
      def migration_dir
        return Roomer.shared_migrations_directory if shared?
        return Roomer.tenanted_migrations_directory
      end
    end
  end
end
