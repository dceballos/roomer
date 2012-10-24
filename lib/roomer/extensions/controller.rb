module Roomer
  module Extensions
    module Controller
      def self.included(base)
        base.around_filter :roomer_set_current_tenant!
      end
      protected
      def roomer_set_current_tenant!
        Roomer::with_tenant_from_request(request) do
          yield
        end
      end
      def current_tenant
        Roomer.current_tenant
      end
    end
  end
end
