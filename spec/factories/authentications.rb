FactoryGirl.define do
  factory :authentication do
    uid { generate(:uid) }
    provider "Provider"
    user
  end
end
