class CreateMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :members do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :station_name, null: false
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
