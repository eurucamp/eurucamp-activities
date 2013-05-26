class ActivityDecorator < Draper::Decorator
  delegate_all

  def creator_name
    creator.name
  end

  def relation_ship_with(user)
    if user.nil?                            then "default"
    elsif object.creator == user            then "owner"
    #elsif object.participants.include? user then "participant"
    else                                         "default"
    end
  end

  def status
    today = Date.current
    if object.start_at > today              then "upcoming"
    elsif object.start_at.to_date == today  then "today"
    else                                         "archive"
    end
  end

  def full_by
    rand(100)
  end

  def time
    # Case for "Anytime" needed
    object.start_at.strftime("%A, %-d.%-m / %k:%M &ndash; ") +
      (object.start_at + object.time_frame.minutes).strftime("%k:%M")
  end

end
