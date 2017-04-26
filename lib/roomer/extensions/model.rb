module Roomer
  module Extensions
    module Model
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # Sets the roomer scope for the model
        def roomer(scope)
          case scope
            when :shared
              @roomer_scope = :shared
            when :tenanted
              @roomer_scope = :tenanted
            else
              raise "Invalid roomer model scope.  Choose :shared or :tenanted"
          end
        end

        # Confirms if model is shared
        # @return [True,False]
        def shared?
          @roomer_scope == :shared
        end

        # Confirms if model is scoped by tenant
        # @return [True,False]
        def tenanted?
          @roomer_scope == :tenanted
        end
      end
    end
  end
end
