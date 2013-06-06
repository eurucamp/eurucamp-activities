class Activity < ActiveRecord::Base
  DEFAULT_LIMIT = 100

  attr_accessor :event
  attr_writer :participation_source # DI

  belongs_to :creator, class_name: "User"
  has_many :participations, :dependent => :destroy
  has_many :participants, through: :participations, class_name: "User"

  validates :start_time, presence: true, allow_blank: false, if: ->{ !anytime? }
  validates :end_time, presence: true, allow_blank: false, if: ->{ !anytime? }
  validates :anytime, presence: true, allow_blank: false, allow_nil: false, if: ->{ start_time.blank? && end_time.blank? }
  validates :name, presence: true, allow_blank: false, uniqueness: true
  validates :location, presence: true, allow_blank: false
  validates :limit_of_participants, numericality: {greater_than: 0}, allow_nil: true
  validate  :time_frame_order, if: ->{ !anytime && event && start_time.present? && end_time.present? }
  validate  :during_the_event, if: ->{ !anytime && event && start_time.present? && end_time.present? }
  validates :event, presence: true
  
  before_validation :clear_time_frame, if: ->{ anytime }
  after_initialize :set_defaults
  
  class << self
    def recent(limit = DEFAULT_LIMIT)
      where("start_time >= :t OR anytime = true", t: 1.month.ago)
        .limit(limit)
        .order("anytime DESC, start_time ASC")
    end

    def all_activities(limit = DEFAULT_LIMIT)
      limit(limit)
    end

    def today
      where(":t between start_time and end_time", t: Date.current)
    end

    def created_by(user)
      where(creator_id: user)
    end

    def participated_by(user)
      includes(:participations).where(participations: { user_id: user })
    end
  end

  def full_by
    limit_of_participants.nil? ? 0 : [100.0 * participations_count / limit_of_participants.to_f, 100.0].min
  end

  def anybody_can_join?
    limit_of_participants.nil?
  end

  def today?
    return true if anytime?
    t = Time.now.end_of_day
    t > start_time && t < end_time
  end

  def upcoming?
    start_time > Time.now.end_of_day
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

    def clear_time_frame
      self.start_time, self.end_time = nil, nil
    end
    
    def set_defaults
      self.limit_of_participants ||= 10
    end
    
    def time_frame_order
      errors.add(:end_time, I18n.t("activities.errors.end_time.before_start")) if end_time < start_time
    end

    def during_the_event
      errors.add(:start_time, I18n.t("activities.errors.end_time.too_early")) if start_time < event.start_time
      errors.add(:end_time, I18n.t("activities.errors.end_time.too_late")) if end_time > event.end_time
    end

end
