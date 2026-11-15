FactoryBot.define do
  factory :user do
    name { "テスト幹事" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    nearest_station_name { "高円寺" }
    nearest_station_lat { 35.7053 }
    nearest_station_lng { 139.6497 }
  end
end