require 'faker'

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    first_name { 'Mr.' }
    last_name { 'Fake' }
    role { 5 }
  end
end
