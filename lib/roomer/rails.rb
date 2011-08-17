module Roomer
  class RoomerEngine < ::Rails::Engine

    initializer 'roomer.extensions' do |app|
      ActiveSupport.on_load(:active_record) do
        class << self
          # Sets the roomer scope for the model and changes the model's table_name_prefix
          # If :shared is passed, the global schema will be used as the table name prefix
          # if :tenanted is pased, the current tenant's schema will be used as the table name prefix
          # @return [Symbol] :shared or :tenanted
          def roomer(scope)
            case scope
              when :shared
                @roomer_scope = :shared
              when :tenanted
                @roomer_scope = :tenanted
              else
                raise "Invalid roomer model scope.  Choose :shared or :tenanted"
            end
            unless self.include?(Roomer::Model)
              include Roomer::Model
            end
          end
        end
      end

      ActiveSupport.on_load(:action_controller) do
        include Roomer::Controller
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
