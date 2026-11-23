require "rails_helper"

RSpec.describe PlaceSearchService do
  describe ".fetch_restaurants" do
    around do |example|
      original_cache = Rails.cache
      Rails.cache = ActiveSupport::Cache::MemoryStore.new
      example.run
    ensure
      Rails.cache = original_cache
    end

    it "APIキー未設定時はフォールバック店舗3件を返すこと" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("GOOGLE_MAPS_API_KEY").and_return(nil)

      shops = PlaceSearchService.fetch_restaurants(lat: 35.7058, lng: 139.6658, station_name: "中野")
      expect(shops.size).to eq(3)
      expect(shops.first[:name]).to include("中野")
    end

    it "Google Places APIが正常応答した場合は上位3件を整形して返すこと" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("GOOGLE_MAPS_API_KEY").and_return("dummy_key")

      stub_request(:get, %r{maps\.googleapis\.com/maps/api/place/nearbysearch/json}).to_return(
        status: 200,
        body: {
          results: [
            { "name" => "お店1", "rating" => 4.5, "vicinity" => "東京都中野区", "place_id" => "p1" },
            { "name" => "お店2", "rating" => 4.2, "vicinity" => "東京都中野区", "place_id" => "p2" },
            { "name" => "お店3", "rating" => 4.0, "vicinity" => "東京都中野区", "place_id" => "p3" },
            { "name" => "お店4", "rating" => 3.9, "vicinity" => "東京都中野区", "place_id" => "p4" }
          ]
        }.to_json
      )

      shops = PlaceSearchService.fetch_restaurants(lat: 35.7058, lng: 139.6658, station_name: "中野")
      expect(shops.size).to eq(3)
      expect(shops.map { |s| s[:name] }).to eq(["お店1", "お店2", "お店3"])
    end

    it "同一駅・座標で2回目以降はキャッシュを返しAPIを重複呼び出ししないこと" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("GOOGLE_MAPS_API_KEY").and_return("dummy_key")

      stub = stub_request(:get, %r{maps\.googleapis\.com/maps/api/place/nearbysearch/json}).to_return(
        status: 200,
        body: {
          results: [
            { "name" => "キャッシュ店1", "rating" => 4.3, "vicinity" => "東京都中野区", "place_id" => "c1" }
          ]
        }.to_json
      )

      first_shops = PlaceSearchService.fetch_restaurants(lat: 35.7058, lng: 139.6658, station_name: "中野")
      second_shops = PlaceSearchService.fetch_restaurants(lat: 35.7058, lng: 139.6658, station_name: "中野")

      expect(first_shops.first[:name]).to eq("キャッシュ店1")
      expect(second_shops).to eq(first_shops)
      expect(stub).to have_been_requested.once
    end

    it "APIエラー時のフォールバック結果はキャッシュしないこと" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("GOOGLE_MAPS_API_KEY").and_return("dummy_key")

      stub_request(:get, %r{maps\.googleapis\.com/maps/api/place/nearbysearch/json})
        .to_return(status: 500, body: "")
        .then.to_return(
          status: 200,
          body: {
            results: [
              { "name" => "復旧後のお店", "rating" => 4.4, "vicinity" => "東京都中野区", "place_id" => "r1" }
            ]
          }.to_json
        )

      first_shops = PlaceSearchService.fetch_restaurants(lat: 35.7058, lng: 139.6658, station_name: "中野")
      second_shops = PlaceSearchService.fetch_restaurants(lat: 35.7058, lng: 139.6658, station_name: "中野")

      expect(first_shops.first[:name]).to include("中野")
      expect(second_shops.first[:name]).to eq("復旧後のお店")
    end
  end
end