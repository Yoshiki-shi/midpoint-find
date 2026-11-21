class CreateMeetingEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :meeting_events do |t|
      t.references :user, null: true, foreign_key: true
      t.string :title
      t.string :midpoint_station_name
      t.string :midpoint_line_name
      t.float :midpoint_lat
      t.float :midpoint_lng
      t.string :share_token

      t.timestamps
    end
    add_index :meeting_events, :share_token, unique: true
  end
end
