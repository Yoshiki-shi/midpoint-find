require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションチェック' do
    it '有効な属性であればvalidであること' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'nameが空欄の場合はinvalidであること' do
      user = build(:user, name: '')
      expect(user).not_to be_valid
    end
  end
end