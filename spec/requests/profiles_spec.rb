require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  let(:user) { create(:user, password: "password123", password_confirmation: "password123") }

  describe "ログインしていない場合" do
    it "プロフィール編集ページにアクセスするとログインページにリダイレクトされること" do
      get edit_profile_path
      expect(response).to redirect_to(login_path)
    end
  end

  describe "ログインしている場合" do
    before do
      post login_path, params: { email: user.email, password: "password123" }
    end

    it "プロフィール編集ページに正常にアクセスできること" do
      get edit_profile_path
      expect(response).to have_http_status(:success)
    end

    it "プロフィール（名前・メールアドレス）を正常に更新できること" do
      patch profile_path, params: { user: { name: "新しい幹事名", email: "new_unique_email@example.com" } }
      expect(response).to redirect_to(profile_path)
      user.reload
      expect(user.name).to eq("新しい幹事名")
      expect(user.email).to eq("new_unique_email@example.com")
    end
  end
end