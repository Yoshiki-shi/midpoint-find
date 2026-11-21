class CreateMeetingParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :meeting_participants do |t|
      t.references :meeting_event, null: false, foreign_key: true
      t.string :name
      t.string :station_name
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
