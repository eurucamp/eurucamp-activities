class Activity < ActiveRecord::Base
  DEFAULT_LIMIT = 100

  attr_accessor :event
  attr_writer :participation_source # DI

  belongs_to :creator, class_name: "User"
  has_many :participations, :dependent => :destroy
  has_many :participants, through: :participations, class_name: "User"

  validates :start_at, presence: true, allow_blank: false
  validates :name, presence: true, allow_blank: false, uniqueness: true
  validates :place, presence: true, allow_blank: false
  validates :limit_of_participants, numericality: {greater_than: 0}, allow_nil: true
  validates :time_frame, numericality: {greater_than: 0}

  def self.recent(limit = DEFAULT_LIMIT)
    where("start_at >= :t", t: 1.month.ago).limit(limit)
  end




  def full_by
    limit_of_participants.nil? ? 0 : [100.0 * participations_count / limit_of_participants.to_f, 100.0].min
  end

  def new_participation(user)
    participation_source.call.tap do |participation|
      participation.activity = self
      participation.participant = user
    end
  end

  def participation(user)
    participations.find_by(user_id: user)
  end

  private

    def participation_source
      @participation_source ||= Participation.public_method(:new)
    end

end
