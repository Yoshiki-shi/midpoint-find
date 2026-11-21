FactoryBot.define do
  factory :meeting_participant do
    meeting_event { nil }
    name { "MyString" }
    station_name { "MyString" }
    lat { 1.5 }
    lng { 1.5 }
  end
end
