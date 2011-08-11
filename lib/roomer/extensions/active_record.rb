class ActiveRecord::Base
  def self.table_name_prefix
    return @@table_name_prefix unless @@table_name_prefix.blank?
    if self.shared?
      Roomer.shared_schema_name
    elsif self.tenanted?
      self.current_tenant[Roomer.tenant_schema_name_column]
    else
      ""
    end
  end
  
  def self.current_tenant=(val)
    key = :"#{self}_current_tenant"
    Thread.current[key] = val
  end
  
  def self.current_tenant
    key = :"#{self}_current_tenant"
    Thread.current[key] || ""
  end

  def self.reset_current_tenant
    key = :"#{self}_current_tenant"
    Thread.current[key] = nil
  end
end

