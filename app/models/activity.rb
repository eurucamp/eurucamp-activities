class Activity < ActiveRecord::Base
  DEFAULT_LIMIT = 100

  attr_accessor :event
  attr_writer :participation_source # DI

  belongs_to :creator, class_name: "User"
  has_many :participations, dependent: :destroy
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
  validate  :image_url_valid, if: ->{ image_url.present? }
  
  before_validation :clear_time_frame, if: ->{ anytime }

  class << self
    def recent(limit = DEFAULT_LIMIT)
      find_recent(limit)
    end

    def all_activities(limit = DEFAULT_LIMIT)
      find_all(limit)
    end

    def today
      find_today
    end

    def with_name_like(name)
      find_with_name_like(name)
    end

    def created_by(user)
      find_created_by(user)
    end

    def participated_by(user)
      find_participated_by(user)
    end

    def order_by_start_time
      order("anytime DESC, start_time ASC")
    end

    private

      def find_all(limit)
        limit(limit).order_by_start_time
      end

      def find_recent(limit)
        where("start_time >= :t OR anytime = true", t: 1.month.ago)
          .limit(limit)
          .order_by_start_time
      end

      def find_today
        where(":t between start_time and end_time", t: Date.current).order_by_start_time
      end

      def find_with_name_like(name)
        where("name ILIKE :q", q: "%#{name}%").order_by_start_time
      end

      def find_created_by(user)
        where(creator_id: user).order_by_start_time
      end

      def find_participated_by(user)
        includes(:participations).where(participations: { user_id: user }).order_by_start_time
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

    def time_frame_order
      errors.add(:end_time, I18n.t("activities.errors.end_time.before_start")) if end_time < start_time
    end

    def during_the_event
      errors.add(:start_time, I18n.t("activities.errors.end_time.too_early")) if start_time < event.start_time
      errors.add(:end_time, I18n.t("activities.errors.end_time.too_late")) if end_time > event.end_time
    end

    def image_url_valid
      errors.add(:image_url, I18n.t("activities.errors.image_url.protocol_not_supported")) unless URI.parse(image_url).kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      errors.add(:image_url, I18n.t("activities.errors.image_url.invalid"))
    end

end
