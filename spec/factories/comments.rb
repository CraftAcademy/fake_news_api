FactoryBot.define do
  factory :comment do
    body { 'MyText' }
    association :article
    association :user
  end
end
