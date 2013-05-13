# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    name "Party!"
    start_at "2013/12/12"
    place "Ballroom"
    time_frame 4*60
  end
end
