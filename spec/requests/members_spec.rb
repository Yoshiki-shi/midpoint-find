require 'rails_helper'

RSpec.describe "Members", type: :request do
  let(:user) { create(:user, password: "password123", password_confirmation: "password123") }

  before do
    stub_request(:get, /express\.heartrails\.com/).to_return(
      status: 200,
      body: {
        response: {
          station: [
            { "name" => "新宿", "prefecture" => "東京都", "line" => "JR山手線", "x" => "139.7006", "y" => "35.6896" }
          ]
        }
      }.to_json
    )
    post login_path, params: { email: user.email, password: "password123" }
  end

  it "メンバー（最寄り駅）を新規登録・削除できること" do
    expect {
      post members_path, params: { member: { name: "自分", station_name: "新宿駅" } }
    }.to change(Member, :count).by(1)

    member = Member.last
    expect(member.station_name).to eq("新宿")
    expect(member.lat).to eq(35.6896)

    expect {
      delete member_path(member)
    }.to change(Member, :count).by(-1)
  end
end