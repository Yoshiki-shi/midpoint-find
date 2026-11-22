require 'rails_helper'

RSpec.describe MidpointCalculatorService do
  describe ".calculate" do
    it "最も遠い2点の中間座標を求め、最寄り駅を返すこと" do
      stub_request(:get, /express\.heartrails\.com/).to_return(
        status: 200,
        body: { response: { station: [{ "name" => "赤羽", "line" => "JR埼京線", "x" => 139.7209, "y" => 35.7777 }] } }.to_json
      )

      points = [
        { name: "よしき", lat: 35.7053, lng: 139.6497 }, # 高円寺
        { name: "友人A", lat: 35.8842, lng: 139.6261 },  # 与野
        { name: "友人B", lat: 35.6896, lng: 139.7006 }   # 新宿
      ]

      result = MidpointCalculatorService.calculate(points)
      expect(result[:station_name]).to eq("赤羽")
      expect(result[:line_name]).to eq("JR埼京線")
    end
  end
end
