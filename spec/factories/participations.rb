# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :participation do
    participant{ FactoryBot.create(:user) }
    activity
  end
end
