require 'rails_helper'

RSpec.describe "Members", type: :request do
  let(:user) { create(:user, password: "password123", password_confirmation: "password123") }
  let!(:member) { create(:member, user: user, name: "友人A", station_name: "新宿駅") }

  describe "ログインしていない場合" do
    it "メンバー一覧ページにアクセスするとログインページにリダイレクトされること" do
      get members_path
      expect(response).to redirect_to(login_path)
    end
  end

  describe "ログインしている場合" do
    before do
      post login_path, params: { email: user.email, password: "password123" }
    end

    it "メンバー一覧ページ（新規登録フォーム含む）に正常にアクセスできること" do
      get members_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("友人A")
    end

    it "新しいメンバーを正常に登録できること" do
      expect {
        post members_path, params: { member: { name: "友人B", station_name: "渋谷駅", lat: 35.6580, lng: 139.7016 } }
      }.to change(user.members, :count).by(1)
      expect(response).to redirect_to(members_path)
    end

    it "メンバー情報を正常に更新できること" do
      patch member_path(member), params: { member: { name: "友人A（更新）", station_name: "東京駅", lat: 35.6812, lng: 139.7671 } }
      expect(response).to redirect_to(members_path)
      member.reload
      expect(member.name).to eq("友人A（更新）")
      expect(member.station_name).to eq("東京駅")
    end

    it "メンバーを正常に削除できること" do
      expect {
        delete member_path(member)
      }.to change(user.members, :count).by(-1)
      expect(response).to redirect_to(members_path)
    end
  end
end