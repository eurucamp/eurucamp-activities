# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    sequence(:name) { |x| "Party! #{x}" }
    start_time "2013/12/12 18:00"
    end_time "2013/12/13 03:00"
    anytime false
    location "Ballroom"
    creator { FactoryGirl.create(:user) }
    event { Event.new("Some Conference", Time.parse("2013/12/10 18:00"), Time.parse("2013/12/18 18:00")) }
  end
end
