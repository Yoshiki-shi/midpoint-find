require 'rails_helper'

RSpec.describe "MeetingEvents", type: :request do
  before do
    stub_request(:get, /express\.heartrails\.com/).to_return(
      status: 200,
      body: { response: { station: [{ "name" => "新宿", "prefecture" => "東京都", "line" => "JR山手線", "x" => 139.7006, "y" => 35.6896 }] } }.to_json
    )
  end

  it "2名以上の出発駅を送信すると中間駅イベントが作成され、結果画面と共有画面が表示できること" do
    expect {
      post meeting_events_path, params: {
        meeting_event: {
          title: "週末飲み会",
          meeting_participants_attributes: {
            "0" => { name: "Aさん", station_name: "高円寺" },
            "1" => { name: "Bさん", station_name: "与野" }
          }
        }
      }
    }.to change(MeetingEvent, :count).by(1)

    event = MeetingEvent.last
    expect(response).to redirect_to(meeting_event_path(event))

    get meeting_event_path(event)
    expect(response).to have_http_status(:success)

    get share_event_path(event.share_token)
    expect(response).to have_http_status(:success)
  end
end
