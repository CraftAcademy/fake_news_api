source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'
gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'rack-cors', require: 'rack/cors'
gem 'active_model_serializers'
gem 'devise_token_auth', github: 'lynndylanhurley/devise_token_auth', branch: 'master'
gem 'faker', git: 'https://github.com/faker-ruby/faker.git', branch: 'master'
gem 'aws-sdk-s3', require: false
gem 'stripe-rails'
gem 'geocoder'
gem 'rest-client', '~> 2.1'

group :development, :test do
  gem 'stripe-ruby-mock', '~> 3.1.0.rc2', require: 'stripe_mock'
  gem 'shoulda-matchers'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'webmock'
  gem 'coveralls', require: false
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end