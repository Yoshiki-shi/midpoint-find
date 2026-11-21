class MeetingParticipant < ApplicationRecord
  belongs_to :meeting_event

  before_validation :resolve_station_coordinates

  validates :station_name, presence: true

  private

  def resolve_station_coordinates
    self.station_name = station_name.to_s.gsub(/駅\z/, "").strip
    return if station_name.blank? || (lat.present? && lng.present?)

    info = StationSearchService.first_coordinates(station_name)
    if info
      self.lat = info[:lat]
      self.lng = info[:lng]
    else
      errors.add(:station_name, "「#{station_name}」の位置情報が見つかりませんでした。実在する駅名を入力してください")
    end
  end
end
