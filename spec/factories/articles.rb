FactoryBot.define do
  factory :article do
    title { "First title" }
    teaser { "some text" }
    body { "Husband found dead allegedly because he wasn't testing first" }
    association :user
  end
end
