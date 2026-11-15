FactoryBot.define do
  factory :member do
    association :user
    sequence(:name) { |n| "テストメンバー#{n}" }
    station_name { "高円寺" }
    lat { 35.7058 }
    lng { 139.6495 }
  end
end