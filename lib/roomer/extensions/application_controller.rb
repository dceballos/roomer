class ApplicationController < ActionController::Base
  before_filter :set_current_tenant

  private
  # Fetches the URL Identifier
  # @return [True, False]
  def url_identifier
    case Roomer.url_routing_strategy
      when :domain
        return request.domain
      when :path
        return params[:roomer_url_identifier]
    end
  end

  def set_current_tenant
    raise "No tenant found for '#{url_identifier}' url identifier" if current_tenant.blank?
    ActiveRecord::Base.current_tenant = current_tenant
  end

  def current_tenant
    @current_tenant ||= ActiveRecord::Base.connection.select_all %{
      SELECT *
      FROM   #{Roomer.full_tenants_table_name}
      WHERE  #{Roomer.tenant_url_identifier_column} = #{url_identifier}
    }
  end
end
