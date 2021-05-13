FactoryBot.define do
  factory :user do
    email { 'random@randon.com' }
    password { 'password' }
    first_name { "Mr." }
    last_name { "Fake" }
    role { 5 }
  end
end
