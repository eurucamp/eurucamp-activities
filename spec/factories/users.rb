# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :user do
    email { generate(:email) }
    password 'qweqweqwe'
  end
end
