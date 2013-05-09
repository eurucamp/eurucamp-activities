module ApplicationHelper
  def twitter_link(user)
    profile_link("http://twitter.com", user.twitter_handle)
  end

  def github_link(user)
    profile_link("http://github.com", user.github_handle)
  end

  def profile_link(base_url, handle)
    handle = h(handle.to_s.sub(/\A@/, ''))
    link_to(truncate(handle, length: 20), "#{base_url}/#{handle}") unless handle.blank?
  end

  def gravatar_avatar_url(user, size)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def twitter_avatar_url(handle)
    "https://twitter.com/api/users/profile_image/#{handle}?size=bigger"
  end

  def avatar_url(user, size = 64)
    return twitter_avatar_url(user.twitter_handle) if user.twitter_handle
    gravatar_avatar_url(user, size)
  end
end
