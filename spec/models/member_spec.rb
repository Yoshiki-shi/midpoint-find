require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:user) { create(:user) }

  describe 'バリデーションのテスト' do
    it '名前と駅名が存在すれば有効であること' do
      member = build(:member, user: user)
      expect(member).to be_valid
    end

    it '名前がなければ無効であること' do
      member = build(:member, user: user, name: nil)
      expect(member).not_to be_valid
    end

    it '駅名がなければ無効であること' do
      member = build(:member, user: user, station_name: nil)
      expect(member).not_to be_valid
    end
  end
end