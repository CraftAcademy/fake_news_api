FactoryBot.define do
  factory :user do
    first_name { "Melon" }
    last_name { "Usk" }
    email { "#{rand(100000)}journalist@gmail.com" }
    password { "password" }
    password_confirmation { "password" }
    role { 1 }
  end
end