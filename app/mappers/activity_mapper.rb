class ActivityMapper < Yaks::Mapper
  link :self, '/activities/{id}'

  attributes :id
  attributes :name, :description, :requirements, :location
  attributes :start_time, :end_time, :anytime
  attributes :participations_count, :limit_of_participants
  attributes :image_url

  has_one :creator, mapper: UserMapper
  has_many :participants, mapper: UserMapper
end
