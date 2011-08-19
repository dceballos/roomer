class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_current_domain
  
  def set_current_domain
    ActiveRecord::Base.subdomain = params[:subdomain]
  end
end
