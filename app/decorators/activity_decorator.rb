class ActivityDecorator < Draper::Decorator
  delegate_all

  def creator_name
    creator.name
  end

  def relation_ship_with(user)
    if user.nil?                            then "default"
    elsif object.creator == user            then "owner"
    elsif object.participants.include? user then "participant"
    else                                         "default"
    end
  end

  def status
    today = Date.current
    if object.start_time > today              then "upcoming"
    elsif object.start_time.to_date == today  then "today"
    else                                         "archive"
    end
  end

  def time
    # Case for "Anytime" needed
    object.start_time.strftime("%A, %-d.%-m / %k:%M &ndash; ") +
      object.end_time.strftime("%k:%M")
  end

end
