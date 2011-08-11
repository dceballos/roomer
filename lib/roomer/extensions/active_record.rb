class ActiveRecord::Base
  def self.table_name_prefix
    subdomain
  end
  
  def self.subdomain=(val)
    Thread.current[:subdomain] = val
  end
  
  def self.subdomain
    Thread.current[:subdomain]
  end
end

