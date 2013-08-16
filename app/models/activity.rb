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
      t = Date.current.beginning_of_day
      custom_order=<<eos
*,
(
  CASE
    WHEN end_time <= '#{t}' THEN 10
    WHEN anytime=true THEN 2
    ELSE 1
  END
) as CUSTOM_ORDER
eos
      select(custom_order).order("CUSTOM_ORDER ASC, start_time ASC, name ASC")
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
        where("(NOT(start_time <= :t1 AND end_time = :t1 ) AND (start_time <= :t2 AND end_time >= :t1)) OR anytime=true", t1: Date.current.beginning_of_day, t2: Date.current.end_of_day).order_by_start_time
      end

      def find_with_name_like(name)
        where("name ILIKE :q", q: "%#{name}%").order_by_start_time
      end

      def find_created_by(user)
        where(creator_id: user).order_by_start_time
      end

      def find_participated_by(user)
        joins(:participations).where(participations: { user_id: user }).order_by_start_time
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
    t1, t2 = Date.current.beginning_of_day, Date.current.end_of_day
    if start_time <= t1 && end_time == t1
      false
    else
      start_time <= t2 && end_time >= t1
    end
  end

  def upcoming?
    start_time > Time.now.end_of_day
  end

  def in_past?
    return false if anytime?
    end_time < Date.current.beginning_of_day
  end

  def full?
    participations_count >= limit_of_participants
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
