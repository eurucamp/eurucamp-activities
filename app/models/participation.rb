class Participation < ActiveRecord::Base
  belongs_to :participant, class_name: "User", foreign_key: "user_id"
  belongs_to :activity, counter_cache: true

  validates :activity_id, presence: true, uniqueness: {scope: [:user_id]}
  validates :user_id, presence: true
end
