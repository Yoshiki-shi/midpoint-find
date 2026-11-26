class MeetingEvent < ApplicationRecord
  belongs_to :user, optional: true
  has_many :meeting_participants, dependent: :destroy
  accepts_nested_attributes_for :meeting_participants, allow_destroy: true, reject_if: :all_blank

  before_validation :ensure_share_token, on: :create

  validates :share_token, presence: true, uniqueness: true
  validate :must_have_at_least_two_participants

  private

  def ensure_share_token
    self.share_token ||= SecureRandom.urlsafe_base64(12)
  end

  def must_have_at_least_two_participants
    valid_participants = meeting_participants.reject(&:marked_for_destruction?).select { |p| p.station_name.present? }
    if valid_participants.size < 2
      errors.add(:base, "出発駅を2名以上入力してください")
    end
  end
  validates :scheduled_at, presence: true
end
