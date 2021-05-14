FactoryBot.define do
  factory :article do
    title { "First title" }
    teaser { "some text" }
    body { "Husband found dead allegedly because he wasn't testing first" }
    association :user
    category {"Flat Earth"}
    after(:build) do |article|
      file = File.open(Rails.root.join('spec', 'fixtures', 'default_photo.png'))
      article.image.attach(io: file, filename: 'default_article_image.png', content_type: 'image/png')
    end
  end
end
