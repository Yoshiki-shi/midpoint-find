class AddNoteToMeetingEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :meeting_events, :note, :text
  end
end
