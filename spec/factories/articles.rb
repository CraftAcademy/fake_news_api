FactoryBot.define do
  factory :article do
    title { 'First title' }
    teaser { 'some text' }
    body { "Husband found dead allegedly because he wasn't testing first" }
    association :user
    backyard { false }
    category { 'Science' }
    premium { true }
    status { 10 }
    language { 'EN' }
    after(:build) do |article|
      file = File.open(Rails.root.join('spec', 'fixtures', 'fake-news-fixture.jpg'))
      article.image.attach(io: file, filename: 'article_image.jpg', content_type: 'image/jpg')
    end
  end

  factory :backyard_article, class: Article do
    title { 'My cat is really spying on me' }
    body { 'My cat was flying yesterday' }
    theme { 'Haunted animals' }
    association :user
    backyard { true }
    location { 'Sweden' }
    status { 10 }
  end
end
