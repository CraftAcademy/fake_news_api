FactoryBot.define do
  factory :article do
    title { "First title" }
    teaser { "some text" }
    body { "Husband found dead allegedly because he wasn't testing first" }
    association :user
    category {"Science"}
    after(:build) do |article|
      file = File.open(Rails.root.join('spec', 'fixtures', 'fake-news-fixture.jpg'))
      article.image.attach(io: file, filename: 'article_image.jpg', content_type: 'image/jpg')
    end
  end
end
