module Roomer
  module Controller
    def self.included(base)
      base.before_filter :ensure_current_tenant
    end

    protected
    # Fetches the URL Identifier
    # @return [True, False]
    def url_identifier
      case Roomer.url_routing_strategy
        when :domain
          return request.domain
        when :path
          return params[:tenant_identifier]
      end
    end

    def ensure_current_tenant
      raise "No tenant found for '#{url_identifier}' url identifier" if current_tenant.blank?
      Roomer.current_tenant = current_tenant
    end

    def current_tenant
      @current_tenant ||= Roomer.tenant_model.find_by_url_identifier(url_identifier)
    end
  end
end
