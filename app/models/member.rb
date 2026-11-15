class Member < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :station_name, presence: true
end