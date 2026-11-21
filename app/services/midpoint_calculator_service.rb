require 'net/http'
require 'json'

class MidpointCalculatorService
  EARTH_RADIUS_KM = 6371.0

  def self.calculate(points)
    valid_points = points.select { |p| p[:lat].present? && p[:lng].present? }
    return nil if valid_points.size < 2

    farthest_pair = valid_points.combination(2).max_by do |p1, p2|
      haversine_distance(p1[:lat], p1[:lng], p2[:lat], p2[:lng])
    end

    mid_lat = (farthest_pair[0][:lat] + farthest_pair[1][:lat]) / 2.0
    mid_lng = (farthest_pair[0][:lng] + farthest_pair[1][:lng]) / 2.0

    nearest_station = fetch_nearest_station(mid_lat, mid_lng)

    {
      midpoint_lat: nearest_station ? nearest_station[:lat] : mid_lat,
      midpoint_lng: nearest_station ? nearest_station[:lng] : mid_lng,
      station_name: nearest_station ? nearest_station[:name] : "中間地点周辺",
      line_name: nearest_station ? nearest_station[:line] : "",
      farthest_pair: farthest_pair
    }
  end

  def self.haversine_distance(lat1, lng1, lat2, lng2)
    return 0.0 if [lat1, lng1, lat2, lng2].any?(&:nil?)

    dlat = (lat2 - lat1) * Math::PI / 180.0
    dlng = (lng2 - lng1) * Math::PI / 180.0
    a = Math.sin(dlat / 2)**2 +
        Math.cos(lat1 * Math::PI / 180.0) * Math.cos(lat2 * Math::PI / 180.0) * Math.sin(dlng / 2)**2
    (2 * EARTH_RADIUS_KM * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))).round(1)
  end

  def self.fetch_nearest_station(lat, lng)
    uri = URI.parse("https://express.heartrails.com/api/json")
    uri.query = URI.encode_www_form(method: "getStations", x: lng.round(6), y: lat.round(6))
    res = Net::HTTP.get_response(uri)
    return nil unless res.is_a?(Net::HTTPSuccess)

    stations = JSON.parse(res.body).dig("response", "station") || []
    first = stations.first
    return nil unless first

    { name: first["name"], line: first["line"], lat: first["y"].to_f, lng: first["x"].to_f }
  rescue StandardError
    nil
  end
end
