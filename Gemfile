source 'https://rubygems.org'

gem 'rails', '~> 8.0.1'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'tzinfo-data', platforms: %i[ windows jruby ]
gem 'solid_cache'
gem 'solid_queue'
gem 'solid_cable'
gem 'bootsnap', require: false
gem 'kamal', require: false
gem 'thruster', require: false
gem 'rack-cors'
gem 'dotenv-rails'
# gem 'sidekiq'
# gem 'dry-validation'
# gem 'u-case'

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'debug', platforms: %i[ mri windows ], require: 'debug/prelude'
  gem 'brakeman', require: false
  gem 'rubocop-rails-omakase', require: false
  gem 'rspec-rails', '~> 6.0'
  # gem 'rspec-sidekiq'
  gem 'faker'
  gem 'factory_bot_rails'
end

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-performance', require: false
end

group :test do
  gem 'rspec-json_matcher', '~> 0.2.0'
end
