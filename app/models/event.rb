class Event
  attr_writer :activity_source # DI
  attr_reader :name, :start_time, :end_time

  def initialize(name, start_time, end_time, fetcher = ->{ Activity.recent })
    @name, @start_time, @end_time = name, start_time, end_time
    @fetcher = fetcher
  end

  def new_activity(author, *args)
    activity_source.call(*args).tap do |activity|
      activity.event = self
      activity.creator = author
    end
  end

  def activity(activity_id)
    activities.where(:id => activity_id).first
  end

  def activities
    fetch
  end

  private

    def fetch
      @fetcher.()
    end

    def activity_source
      @activity_source ||= Activity.public_method(:new)
    end

end