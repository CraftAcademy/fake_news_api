FactoryBot.define do
  factory :user do
    email { "#{rand(10000000000)}random@randon.com" }
    password { 'password' }
  end
end
