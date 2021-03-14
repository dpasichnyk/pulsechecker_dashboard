source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'bigdecimal'
gem 'devise'
gem 'jbuilder', '~> 2.7'
gem 'mini_racer', platforms: :ruby
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.1'
gem 'react_on_rails', '12.0.4'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
gem 'olive_branch', '~> 3.0.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem 'bootsnap', '>= 1.7.0', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'foreman'
  gem 'rspec-rails', '~> 4.0.2'
end

group :development do
  gem 'annotate'
  gem 'listen', '~> 3.3'
  gem 'mailcatcher'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'rubocop', require: false
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'database_cleaner-active_record'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
