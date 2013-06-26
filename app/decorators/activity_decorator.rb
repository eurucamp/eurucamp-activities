class ActivityDecorator < Draper::Decorator
  delegate_all

  def creator_name
    creator.try(:name) || creator.email
  end

  def relation_ship_with(user)
    if user.nil?                            then "default"
    elsif object.creator == user            then "owner"
    elsif object.participants.include? user then "participant"
    else                                         "default"
    end
  end

  def status
    if object.anytime?      then ""
    elsif object.today?     then "today"
    elsif object.upcoming?  then "upcoming"
    else                    "archive"
    end
  end

  def description_markdown
    object.description ? markdown(object.description) : ''
  end

  def requirements_markdown
    object.requirements ? markdown(object.requirements) : ''
  end

  def room_left
    if object.anybody_can_join? then ""
    else
      left = [[object.limit_of_participants - object.participations_count, object.participations_count].min, 0].max
      if    left == 1 then I18n.t("activities.room_left.one")
      elsif left >  0 then I18n.t("activities.room_left.many", left: left)
      else                 I18n.t("activities.room_left.none")
      end
    end
  end

  def time
    if object.anytime?
      I18n.t("activities.anytime")
    else
      alpha, omega, out = object.start_time, object.end_time, ""

      out << I18n.l(alpha, format: :nice_date)
      out << " / "
      out << I18n.l(alpha, format: :time_only)
      out << " &ndash; "
      unless alpha.to_date == omega.to_date
        out << I18n.l(omega, format: :nice_date)
        out << " / "
      end
      out << I18n.l(omega, format: :time_only)
    end
  end

  private

    def markdown(text)
      options = %i(hard_wrap filter_html autolink no_intraemphasis fenced_code_blocks)
      options = options.zip Array.new(options.size) { true }
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, Hash[*options.flatten])
      markdown.render(text).html_safe
    end

end
