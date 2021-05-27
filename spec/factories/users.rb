require 'faker'

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    first_name { 'Mr.' }
    last_name { 'Fake' }
    role { 5 }
  end

  factory :subscriber, class: User do
    email { Faker::Internet.email }
    password { 'password' }
    first_name { 'Mrs.' }
    last_name { 'Fake' }
    role { 2 }
  end
end
