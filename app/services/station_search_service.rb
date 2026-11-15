require 'net/http'
require 'uri'
require 'json'

class StationSearchService
  API_BASE_URL = 'https://express.heartrails.com/api/json'.freeze

  def self.call(station_name)
    new(station_name).execute
  end

  def initialize(station_name)
    @station_name = station_name
  end

  def execute
    return nil if @station_name.blank?

    uri = URI("#{API_BASE_URL}?method=getStations&name=#{URI.encode_www_form_component(@station_name)}")
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    stations = data.dig('response', 'station')
    return nil if stations.blank?

    # 最初の検索ヒット結果の緯度・経度を採用
    station = stations.is_a?(Array) ? stations.first : stations
    {
      lat: station['y']&.to_f,
      lng: station['x']&.to_f
    }
  rescue StandardError => e
    Rails.logger.error("StationSearchService Error: #{e.message}")
    nil
  end
end