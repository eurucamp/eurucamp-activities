# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    name "Party!"
    start_time "2013/12/12 18:00"
    end_time "2013/12/13 03:00"
    place "Ballroom"
    creator { FactoryGirl.create(:user) }
  end
end
