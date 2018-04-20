# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :activity do
    name 'Party!'
    start_time '2013/12/12 18:00'
    end_time '2013/12/13 03:00'
    anytime false
    location 'Ballroom'
    creator { FactoryBot.create(:user) }
    event { Event.new('Some Conference', Time.zone.parse('2013/12/10 18:00'), Time.zone.parse('2013/12/18 18:00')) }
  end
end
