class ActivityDecorator < Draper::Decorator
  delegate_all

  def css_classes
    classes =  [relation_ship_with(h.current_user)]
    classes << 'today' if object.today?
    classes << 'past' if object.in_past?
    classes << 'full' if object.full?
    classes << 'anytime' if object.anytime?
    classes.join(' ')
  end

  def creator_name
    if official
      'Isle of Ruby'
    elsif creator
      creator.name.presence || creator.email
    end
  end

  def relation_ship_with(user)
    if user.nil?                            then 'default'
    elsif object.creator == user            then 'owner'
    elsif object.participants.include? user then 'participant'
    else                                         'default'
    end
  end

  def status
    if object.anytime?      then ''
    elsif object.today?     then 'today'
    elsif object.in_past?   then 'past'
    elsif object.upcoming?  then 'upcoming'
    else                         'archive'
    end
  end

  def description_markdown
    object.description ? markdown(object.description) : '<em>No description added.</em>'.html_safe
  end

  def requirements_markdown
    object.requirements ? markdown(object.requirements) : ''
  end

  def room_left
    if object.anybody_can_join? || object.official then ''
    else
      left = open_spots
      if    left == 1 then I18n.t('activities.room_left.one')
      elsif left >  0 then I18n.t('activities.room_left.many', left: left)
      else                 I18n.t('activities.room_left.none')
      end
    end
  end

  def open_spots
    [[object.limit_of_participants - object.participations_count, 0].max, object.limit_of_participants].min
  end

  def time
    if object.anytime?
      I18n.t('activities.anytime')
    else
      alpha = object.start_time
      omega = object.end_time
      out = ''

      out << I18n.l(alpha, format: :nice_date)
      out << ' / '
      out << I18n.l(alpha, format: :time_only)
      out << ' &ndash; '
      unless alpha.to_date == omega.to_date
        out << I18n.l(omega, format: :nice_date)
        out << ' / '
      end
      out << I18n.l(omega, format: :time_only)
    end
  end

  private

  def markdown(text)
    options = %i[hard_wrap filter_html autolink no_intraemphasis fenced_code_blocks]
    options = options.zip Array.new(options.size) { true }
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, Hash[*options.flatten])
    markdown.render(text).html_safe
  end
end
