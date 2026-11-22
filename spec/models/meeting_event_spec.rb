require 'rails_helper'

RSpec.describe MeetingEvent, type: :model do
  before do
    stub_request(:get, /express\.heartrails\.com/).to_return(
      status: 200,
      body: {
        response: {
          station: [{ "name" => "新宿", "line" => "JR山手線", "x" => 139.7006, "y" => 35.6896 }]
        }
      }.to_json
    )
  end

  it "2名以上の参加者があれば有効であり、share_tokenが自動生成されること" do
    event = MeetingEvent.new(
      title: "テスト会",
      meeting_participants_attributes: [
        { name: "A", station_name: "高円寺" },
        { name: "B", station_name: "与野" }
      ]
    )

    expect(event).to be_valid
    expect(event.share_token).to be_present
  end

  it "参加者が2名未満の場合は無効となること" do
    event = MeetingEvent.new(
      title: "1名だけ",
      meeting_participants_attributes: [
        { name: "A", station_name: "高円寺" }
      ]
    )

    expect(event).not_to be_valid
  end
end
