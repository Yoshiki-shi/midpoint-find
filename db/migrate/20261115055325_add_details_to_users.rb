class AddDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :nearest_station_name, :string
    add_column :users, :nearest_station_lat, :float
    add_column :users, :nearest_station_lng, :float
  end
end
