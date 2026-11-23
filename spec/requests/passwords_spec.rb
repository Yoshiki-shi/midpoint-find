require 'rails_helper'

RSpec.describe "Passwords", type: :request do
  let(:user) { create(:user, password: "oldpassword123", password_confirmation: "oldpassword123") }

  before do
    post login_path, params: { email: user.email, password: "oldpassword123" }
  end

  describe "PATCH /password" do
    it "現在のパスワードが正しければ新しいパスワードに変更できること" do
      patch password_path, params: {
        user: {
          current_password: "oldpassword123",
          password: "newpassword456",
          password_confirmation: "newpassword456"
        }
      }
      expect(response).to redirect_to(profile_path)
      expect(user.reload.authenticate("newpassword456")).to be_truthy
    end

    it "現在のパスワードが間違っている場合は変更が拒否されること" do
      patch password_path, params: {
        user: {
          current_password: "wrongpassword",
          password: "newpassword456",
          password_confirmation: "newpassword456"
        }
      }
      expect(response).to have_http_status(:unprocessable_content)
      expect(user.reload.authenticate("oldpassword123")).to be_truthy
    end
  end
end