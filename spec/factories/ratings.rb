FactoryBot.define do
  factory :rating do
    rating { 5 }
    association :article, :user
  end
end
