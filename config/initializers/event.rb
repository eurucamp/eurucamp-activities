#if Rails.env.production?
#  ::EVENT = Event.new(Settings.event.name, Settings.event.start_time, Settings.event.end_time)
#end
