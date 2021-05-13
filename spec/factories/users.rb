FactoryBot.define do
  factory :user do
    email { "#{rand(10000000000)}random@randon.com" }
    password { 'password' }
    first_name { "Mr." }
    last_name { "Fake" }
    role { 5 }
  end
end
