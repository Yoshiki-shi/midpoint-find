FactoryBot.define do
  factory :member do
    sequence(:name) { |n| "テストメンバー#{n}" }
    station_name { "高円寺駅" }
    lat { 35.7056 }
    lng { 139.6495 }
    association :user
  end
end