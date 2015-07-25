class UserDecorator < Draper::Decorator
  def name
    object.name
  end

  def avatar_url(size)
    h.avatar_url(object, size)
  end
end
