class Tenant < ActiveRecord::Base
  # tell roomer if this is a shared model
  roomer :shared
end
