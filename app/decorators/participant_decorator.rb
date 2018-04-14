class ParticipantDecorator < Draper::Decorator
  def name
    return 'Anonymous' unless object.show_participation
    object.name
  end

  DEFAULT_AVATAR = 'https://www.gravatar.com/avatar/00000000000000000000000000000000.png?s=%{size}'

  def avatar_url(size)
    return DEFAULT_AVATAR % { size: size } unless object.show_participation
    h.avatar_url(object, size)
  end
end
