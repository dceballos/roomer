class PersonController < ApplicationController
  
  def show
    Rails.logger.info "DEBUG ************ Starting #{Person.subdomain}"
    sleep 30
    Rails.logger.info "DEBUG ************ Completed #{Person.subdomain}"
  end
end
