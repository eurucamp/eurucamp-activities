User.transaction do |tx|
  creator = User.new(
    email: "johnny@cash.com",
    name: "Johnny Cash"
  )
  creator.password = creator.password_confirmation = "qweqweqwe"
  creator.save!

  participant = User.new(
    email: "johnny@begood.com",
    name: "Johnny Begood"
  )
  participant.password = participant.password_confirmation = "qweqweqwe"
  participant.save!

  activity = Activity.new(
    name: "Party!",
    start_at: 1.day.from_now.to_time,
    place: "Pool",
    time_frame: 200,
    limit_of_participants: 2,
    creator: creator
  )
  activity.participants << participant
  activity.save!
end
