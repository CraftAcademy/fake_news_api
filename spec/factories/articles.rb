FactoryBot.define do
  factory :article do
    title { 'First title' }
    teaser { 'some text' }
    body { ["Husband found dead allegedly because he wasn't testing first", 'Wife devastated.'] }
    association :user
    backyard { false }
    category { 'Science' }
    premium { true }
    published { false }
    after(:build) do |article|
      file = File.open(Rails.root.join('spec', 'fixtures', 'fake-news-fixture.jpg'))
      article.image.attach(io: file, filename: 'article_image.jpg', content_type: 'image/jpg')
    end
  end

  factory :backyard_article, class: Article do
    title { 'My cat is really spying on me' }
    body { ['My cat was flying yesterday', 'Really a surreal experience'] }
    theme { 'Haunted animals' }
    association :user
    backyard { true }
    location { 'Sweden' }
  end
end
