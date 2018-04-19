FactoryBot.define do
  sequence(:email) { |n| "person#{n}@example.com" }
  sequence(:uid) { |n| "uid#{n}" }
end
