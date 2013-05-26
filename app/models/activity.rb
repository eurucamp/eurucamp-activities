class Activity < ActiveRecord::Base
  DEFAULT_LIMIT = 100

  attr_accessor :event

  belongs_to :creator, class_name: "User"

  validates :start_at, presence: true, allow_blank: false
  validates :name, presence: true, allow_blank: false, uniqueness: true
  validates :place, presence: true, allow_blank: false
  validates :limit_of_participants, numericality: {greater_than: 0}, allow_nil: true
  validates :time_frame, numericality: {greater_than: 0}

  def self.recent(limit = DEFAULT_LIMIT)
    where("start_at >= :t", t: 1.month.ago).limit(limit)
  end

end
