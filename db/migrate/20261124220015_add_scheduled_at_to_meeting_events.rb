class AddScheduledAtToMeetingEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :meeting_events, :scheduled_at, :datetime
  end
end
