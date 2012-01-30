module Roomer
  module Extensions
    module Controller
      def self.included(base)
        base.before_filter :set_current_tenant!
      end

      protected
      # Fetches the URL Identifier
      # @return [True, False]
      def url_identifier
        case Roomer.url_routing_strategy
          when :domain
            return request.host
          when :path
            return params[:tenant_identifier]
        end
      end

      # Sets the current tenant, this method is set in the before_filter
      # @throws if tenant is not found
      def set_current_tenant!
        return if Roomer.current_tenant.try(:url_identifier) == url_identifier

        # Raise an exception if the current tenant is blank
        raise "No tenant found for '#{url_identifier}' url identifier" if current_tenant.blank?
        Roomer.current_tenant = current_tenant
      end

      # Returns the current tenant
      # @returns Roomer.tenant_model
      # @see Roomer.model
      def current_tenant
        @current_tenant ||= Roomer.tenant_model.find_by_url_identifier(url_identifier)
      end
    end
  end
end
