class Activity
  attr_accessor :event, :name, :start_at

  def initialize(attrs = {})
    attrs.each do |k,v| send("#{k}=",v) end
  end

  def recent
    []
  end

end