module Roomer
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      
      desc "Creates a Roomer initializer for your application."
      
      def copy_initializer
        template "roomer.rb", "config/initializers/roomer.rb"
      end
      
      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end