require 'yaks-rails'

Yaks.configure do
  default_format :json_api

  map_to_primitive Date, Time, DateTime, ActiveSupport::TimeWithZone, &:iso8601
end
