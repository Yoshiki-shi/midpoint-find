class User < ApplicationRecord
  # パスワードのセキュリティ設定（暗号化、確認用パスワードの一致チェックなど）
  has_secure_password
  
  # メールアドレスを小文字に変換するよ
  before_validation { email.downcase! }
  
  # 名前のバリデーション
  # 空でないことと、文字数は50文字以内だよ
  validates :name, presence: true, length: { maximum: 50 }

  # メールアドレスのバリデーション
  # 空でないことと、文字数は255文字以内、メールアドレスの形式であること、そして一意であることを確認する
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true # ← ここを少しインデント（字下げ）を合わせるとキレイ！
                    
  # パスワードの長さバリデーション（空でないこと、最低6文字以上）
  validates :password, presence: true, length: { minimum: 6 }
end