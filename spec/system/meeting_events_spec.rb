require 'rails_helper'

RSpec.describe "MeetingEvents E2E", type: :system do
  before do
    driven_by(:rack_test)
    stub_request(:get, /express\.heartrails\.com/).to_return(
      status: 200,
      body: {
        response: {
          station: [
            { "name" => "中野", "prefecture" => "東京都", "line" => "JR中央線", "x" => 139.6658, "y" => 35.7058 }
          ]
        }
      }.to_json
    )
  end

  it "出発駅を入力して中間駅と店舗候補が表示され、共有URLでも閲覧できること" do
    visit new_meeting_event_path

    fill_in "イベント名（任意）", with: "金曜夜の飲み会"
    within all(".participant-row")[0] do
      find("[data-field='name']").set("自分")
      find("[data-field='station']").set("高円寺")
    end
    within all(".participant-row")[1] do
      find("[data-field='name']").set("仲間")
      find("[data-field='station']").set("与野")
    end

    click_button "中間駅とお店候補を検索する"

    expect(page).to have_content("中野駅")
    expect(page).to have_content("周辺のお店候補（3件）")

    event = MeetingEvent.order(:id).last
    visit share_event_path(event.share_token)
    expect(page).to have_content("中野駅")
  end

  it "出発駅が1名分しか入力されていない場合はエラーメッセージが表示されること" do
    visit new_meeting_event_path

    within all(".participant-row")[0] do
      find("[data-field='station']").set("高円寺")
    end

    click_button "中間駅とお店候補を検索する"

    expect(page).to have_content("出発駅を2名以上入力してください")
  end
end
