class Event
  attr_writer :activity_source, :all_activities_fetcher, :recent_activities_fetcher # DI
  attr_reader :name, :start_time, :end_time

  def initialize(
      name       = Settings.event.name,
      start_time = Settings.event.start_time,
      end_time   = Settings.event.end_time,
      recent_activities_fetcher = ->{ Activity.recent },
      all_activities_fetcher    = ->{ Activity.all_activities })
    @name, @start_time, @end_time = name, start_time, end_time
    @recent_activities_fetcher = recent_activities_fetcher
    @all_activities_fetcher = all_activities_fetcher
  end

  def new_activity(author, *args)
    activity_source.call(*args).tap do |activity|
      if activity
        activity.start_time = @start_time if activity.start_time.blank?
        activity.end_time = @end_time if activity.end_time.blank?
        activity.event = self
        activity.creator = author
      end
    end
  end

  def counters(user)
    {
      today: Activity.today.count(:all),
      all: Activity.count,
      participant: user.nil? ? 0 : Activity.participated_by(user).count(:all),
      owner: user.nil? ? 0 : Activity.created_by(user).count(:all)
    }
  end

  def activity(activity_id)
    find_activity(activity_id).tap do |activity|
      activity.event = self if activity
    end
  end

  def recent_activities
    fetch_recent
  end

  def all_activities
    fetch_all_activities
  end

  def search_activities(author = nil, query_string = "", filter = "all")
    query = all_activities
    # TODO: consider using squeel in the future (doesn't work well with rails 4.beta1 ...)
    query = query.with_name_like(query_string) if query_string.present?
    if filter.present?
      query = if filter == "today"
        query.today
      elsif filter == "owner"
        query.created_by(author)
      elsif filter == "participant"
        query.participated_by(author)
      else
        query
      end
    end
    query
  end
  alias_method :activities, :search_activities

  def activities_per_day(author = nil, query_string = "", filter = "all")
    activities = search_activities(author, query_string, filter)
    activities = activities.to_a.sort_by { |activity| activity.start_time }

    activities.each_with_object(Hash.new { [] }) do |activity, grouped_by_day|
      activity.dates.each do |date|
        grouped_by_day[date] += [activity]
      end
    end
  end

  private

    def fetch_recent
      @recent_activities_fetcher.()
    end

    def fetch_all_activities
      @all_activities_fetcher.()
    end

    def find_activity(activity_id)
      all_activities.where(id: activity_id).first
    end

    # Allow to replace db engine for tests
    def activity_source
      @activity_source ||= Activity.public_method(:new)
    end

end
