FactoryGirl.define do
  factory :worker do
    first_name 'Workie'
    last_name 'Workerson'
    sequence(:mobile_number, 100_000_000) { |n| "+27#{n}" }
    password 'please123'
    confirmed_at Time.now
  end
end
