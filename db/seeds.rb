# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

test_user = User.find_or_initialize_by(email: "test@example.com")
test_user.assign_attributes(
  name: "テスト幹事",
  password: "Password123!",
  password_confirmation: "Password123!",
  nearest_station_name: "高円寺"
)
test_user.save!

[
  { name: "仲間A", station_name: "中野" },
  { name: "仲間B", station_name: "与野" }
].each do |member_attrs|
  member = test_user.members.find_or_initialize_by(name: member_attrs[:name])
  member.station_name = member_attrs[:station_name]
  member.save!
end
User.find_or_create_by!(email: "test@example.com") do |user|
  user.name = "テスト幹事"
  user.password = ENV.fetch("MAINTENANCE_USER_PASSWORD", "Password123!")
  user.password_confirmation = user.password
end
