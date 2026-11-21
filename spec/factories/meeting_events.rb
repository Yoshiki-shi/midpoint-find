FactoryBot.define do
  factory :meeting_event do
    user { nil }
    title { "MyString" }
    midpoint_station_name { "MyString" }
    midpoint_line_name { "MyString" }
    midpoint_lat { 1.5 }
    midpoint_lng { 1.5 }
    share_token { "MyString" }
  end
end
