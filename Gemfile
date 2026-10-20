source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '4.0.7'

gem 'devise', '~> 5.0', '>= 5.0.4'
gem 'govuk_design_system_formbuilder'
gem 'govuk_notify_rails', '~> 3.0'
gem 'govuk-pay-ruby-client', github: 'ministryofjustice/govuk-pay-ruby-client', tag: 'v1.0.3'
gem 'mimemagic', '~> 0.4.0'
gem 'pg', '~> 1.1'
gem 'puma'
gem 'rails', '~> 8.1'
gem 'responders'
gem 'json', '~> 2.21.2'


# frontend assets management
gem 'propshaft'
gem 'cssbundling-rails'
gem 'jsbundling-rails'


# Sentry
gem "stackprof"
gem "sentry-ruby"
gem "sentry-rails"
gem "sentry-sidekiq"
gem 'vernier'


gem 'uglifier'
gem 'uk_postcode'
gem 'virtus'
gem 'parser', '~> 3.1', '>= 3.1.1.0'
gem 'tzinfo', '~> 2.0.5'

# Back office
gem 'omniauth-auth0', '~> 3.2.0'
gem 'omniauth-rails_csrf_protection'

# Caching and jobs processing
gem 'redis'
gem "redis-actionpack"
gem 'sidekiq', '~> 8.1'
gem 'sidekiq_alive'

# PDF generation
gem 'combine_pdf', '~> 1.0'
gem 'grover'

# Amazon S3 blob storage
gem 'aws-sdk-s3', '~> 1'
gem 'clamby'
gem 'sanitize', '~> 7.0'

gem 'listen'
gem 'ostruct'
gem 'csv'
gem 'cgi', '~> 0.5.1'
gem 'mutex_m'

gem 'prometheus-client', '~> 4.2.5'

group :development, :production do
  gem 'lograge'
  gem 'logstash-event'
end

group :development do
  gem 'better_errors'
  gem "bundler-audit", "~> 0.9.1"
  gem 'openssl'
end

source 'https://oss:Q7U7p2q2XlpY45kwqjCpXLIPf122rjkR@gem.mutant.dev' do
  gem 'mutant-license',                '0.1.1.2.1739399027284447558325915053311580324856.7'
end

group :development, :test do
  gem 'dotenv-rails', '~> 3.1', '>= 3.1.2'
  gem 'mutant-rspec'
  gem 'pry'
  gem 'debug'
  gem 'rspec-rails'
  gem 'ruby-prof'
  gem 'web-console'
end

group :test do
  gem 'brakeman'
  gem 'capybara'
  gem 'capybara-screenshot', '~> 1.0', '>= 1.0.25'
  gem 'cucumber', '~> 11.1'
  gem 'cucumber-rails', require: false
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter'
  gem 'rubocop'
  gem 'rubocop-performance', require: false
  gem 'selenium-webdriver', '>= 4.24.0'
  gem 'simplecov', require: false
  gem 'simplecov-rcov'
  gem 'site_prism'
  gem 'webmock'
  gem 'database_cleaner'
  gem 'parallel_tests'
  gem 'cuprite'
end
