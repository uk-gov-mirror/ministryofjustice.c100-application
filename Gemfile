source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'devise', '~> 4.7.1'
gem 'email_validator', '< 2.0.0'
gem 'govuk_design_system_formbuilder', '~> 1.1.11'
gem 'govuk_notify_rails', '~> 2.1.0'
gem 'jquery-rails'
gem 'omniauth-auth0', '~> 2.2'
gem 'omniauth-rails_csrf_protection'
gem 'pg', '~> 1.1'
gem 'puma'
gem 'rails', '~> 5.2.4'
gem 'responders'
gem 'sass-rails', '< 6.0.0'
gem 'sentry-raven', '~> 2.0'
gem 'uglifier'
gem 'uk_postcode'
gem 'virtus'

# Caching and jobs processing
gem 'redis'
gem 'sidekiq', '~> 6.0'

# PDF generation
gem 'combine_pdf', '~> 1.0'
gem 'wicked_pdf', '~> 1.4.0'
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
  gem 'cucumber'
  gem 'cucumber-rails', require: false
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter'
  gem 'rubocop', '~> 0.52.1', require: false
  gem 'rubocop-rspec', require: false
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'simplecov-rcov'
  gem 'webmock'
end
