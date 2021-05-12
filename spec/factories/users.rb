FactoryBot.define do
  factory :user do
    first_name { "Melon" }
    last_name { "Usk" }
    email { "journalist@gmail.com" }
    password { "password" }
    password_confirmation { "password" }
    role { 1 }
  end
end