module Roomer
  module Generators
    class ModelGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
      
      
      def generate_model
        puts attributes
        #invoke "active_record:model", [name], :migration => false #unless model_exists? && behavior == :invoke
      end
    end
  end
end