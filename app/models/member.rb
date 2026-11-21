class Member < ApplicationRecord
  belongs_to :user
  before_validation :normalize_and_geocode_station

  validates :name, presence: true, length: { maximum: 30 }
  validates :station_name, presence: true, length: { maximum: 50 }

  private

  def normalize_and_geocode_station
    self.station_name = station_name.to_s.gsub(/駅\z/, "").strip
    return if station_name.blank? || (lat.present? && lng.present? && !station_name_changed?)

    if defined?(StationSearchService)
      info = StationSearchService.call(station_name)
      if info
        self.lat = info[:lat]
        self.lng = info[:lng]
      end
    end
  end
end