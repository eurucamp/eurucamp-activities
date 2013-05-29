# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :participation do
    participant{ FactoryGirl.create(:user) }
    activity
  end
end
