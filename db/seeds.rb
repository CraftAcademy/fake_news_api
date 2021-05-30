require 'uri'
require 'faker'

articles = JSON.parse(File.read('db/seed_data/articles.json'))
backyards = JSON.parse(File.read('db/seed_data/backyards.json'))

puts 'Creating journalists...'
journalist = User.create(email: 'mrfake@fakenews.com', password: 'password', password_confirmation: 'password',
                         first_name: 'Mr.', last_name: 'Fake', role: 5)
(0..5).each do |_i|
  User.create(email: Faker::Internet.email, password: 'password', first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name, role: 5)
end

puts 'Creating subscribers...'
subscriber = User.create(email: 'subscriber@gmail.com', password: 'password', password_confirmation: 'password',
                         first_name: 'Bob', last_name: 'Kramer', role: 2)
(0..5).each do |_i|
  User.create(email: Faker::Internet.email, password: 'password', first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name, role: 2)
end

puts 'Creating editor....'
editor = User.create(email: 'editor@gmail.com', password: 'password', password_confirmation: 'password',
                     first_name: 'Sam', last_name: 'Kramer', role: 10)

puts 'Spreading the truth...'
articles.each do |article|
  article_db = Article.create(title: article['title'], teaser: article['teaser'], body: article['body'], created_at: (DateTime.now - rand(7)),
                              category: article['category'], language: article['language'], user_id: journalist.id, premium: [true, false].sample, status: 'published')
  Rating.create(user_id: journalist.id, article_id: article_db.id, rating: [3, 4, 5].sample)
  image_file = URI.open(article['image'])
  article_db.image.attach(io: image_file, filename: 'article_image.jpg', content_type: 'image/jpg')
end

puts 'My opinion is gospel...'
Article.where(backyard: false).each do |article|
  rand(4).times { article.comments.create(body: Faker::ChuckNorris.fact, user_id: User.where(role: 2).sample.id) }
end

puts 'Generating valid insights...'
backyards.each do |backyard|
  backyard_db = Article.create(title: backyard['title'], body: backyard['body'], backyard: true, location: backyard['location'],
                               theme: backyard['theme'], user_id: subscriber.id, status: 'published')
end
