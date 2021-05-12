FactoryBot.define do
  factory :article do
    title { "First title" }
    teaser { "some text" }
    association :user
  end
end
