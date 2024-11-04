# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '3.1.4'
gem 'rails', '~> 7.0.8', '>= 7.0.8.1'
gem 'sprockets-rails'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'jsbundling-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'redis', '~> 4.0'
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]
gem 'bootsnap', require: false

gem 'jwt'
gem 'pagy', '~> 8.1'
gem 'sidekiq'
gem 'slim-rails'
gem 'sassc-rails'

gem 'stackprof'
gem 'sentry-ruby'
gem 'sentry-rails'
gem 'dotenv-rails'
gem 'overcommit', '~> 0.60.0'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'bundler-audit'
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'rspec-sidekiq'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
end

gem 'devise', '~> 4.9'
gem 'lograge'
gem "logstash-event"
