source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version')

gem 'devise', '~> 4.7.1'
gem 'govuk_design_system_formbuilder', '~> 2.1.2'
gem 'govuk_notify_rails', '~> 2.1.0'
gem 'govuk-pay-ruby-client', '~> 1.0.2'
gem 'jquery-rails'
gem 'pg', '~> 1.1'
gem 'puma'
gem 'rails', '~> 5.2.4'
gem 'responders'
gem 'sass-rails', '< 6.0.0'
gem 'sentry-raven', '~> 3.0'
gem 'uglifier'
gem 'uk_postcode'
gem 'virtus'

# Back office
gem 'omniauth-auth0'
gem 'omniauth-rails_csrf_protection'

# Caching and jobs processing
gem 'redis'
gem 'sidekiq', '~> 6.0'

# PDF generation
gem 'combine_pdf', '~> 1.0'
gem 'wicked_pdf', '~> 2.1.0'
gem 'wkhtmltopdf-binary-edge-alpine', '~> 0.12.5'

group :production do
  gem 'lograge'
  gem 'logstash-event'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'i18n-debug'
  gem 'web-console'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'mutant', '< 0.9.0'
  gem 'mutant-rspec'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
end

group :test do
  gem 'brakeman'
  gem 'capybara'
  gem 'cucumber', '< 4.0.0'
  gem 'cucumber-rails', require: false
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'simplecov-rcov'
  gem 'webdrivers'
  gem 'webmock'
end
