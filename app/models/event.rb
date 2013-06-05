class Event
  attr_writer :activity_source # DI
  attr_reader :name, :start_time, :end_time

  def initialize(name, start_time, end_time,
      recent_activities_fetcher = ->{ Activity.recent },
      all_activities_fetcher = ->{ Activity.all_activities })
    @name, @start_time, @end_time = name, start_time, end_time
    @recent_activities_fetcher = recent_activities_fetcher
    @all_activities_fetcher = all_activities_fetcher
  end

  def new_activity(author, *args)
    activity_source.call(*args).tap do |activity|
      if activity
        activity.event = self
        activity.creator = author
      end
    end
  end

  def activity(activity_id)
    all_activities.where(:id => activity_id).first.tap do |activity|
      activity.event = self if activity
    end
  end

  def recent_activities
    fetch_recent
  end

  def all_activities
    fetch_all_activities
  end
  alias_method :activities, :all_activities

  private

    def fetch_recent
      @recent_activities_fetcher.()
    end

    def fetch_all_activities
      @all_activities_fetcher.()
    end

    def activity_source
      @activity_source ||= Activity.public_method(:new)
    end

end