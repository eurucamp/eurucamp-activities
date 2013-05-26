User.transaction do |tx|
  user = User.new(
    email: "johnny@cash.com",
    name: "Johnny Cash"
  )
  user.password=user.password_confirmation="qweqweqwe"
  user.save!

  Activity.create!(
    name: "Party!",
    start_at: 1.day.from_now.to_time,
    place: "Pool",
    time_frame: 200,
    creator: user
  )
end
