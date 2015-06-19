class UserMapper < Yaks::Mapper
  include ApplicationHelper # TODO: please don't

  link :self, '/users/{id}'

  attributes :id
  attributes :email,
    :name,
    :twitter_handle,
    :github_handle

  attribute :avatar do
    avatar_url(object, 48) if object.email
  end
end
