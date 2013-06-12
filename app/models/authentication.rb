class Authentication < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :provider, presence: true, uniqueness: { scope: [:user_id] }
  validates :uid, presence: true

end
