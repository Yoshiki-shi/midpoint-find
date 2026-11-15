class Member < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { maximum: 30 }
  validates :station_name, presence: true, length: { maximum: 50 }
  validates :lat, presence: true, numericality: true
  validates :lng, presence: true, numericality: true
end