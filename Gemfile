source 'https://rubygems.org'

ruby '2.4.4'

gem 'devise', '~> 4.4.3'
gem 'email_validator'
gem 'govuk_elements_form_builder', '~> 1.2.0'
gem 'govuk_elements_rails', '~> 3.0'
gem 'govuk_notify_rails', '~> 2.0.0'
gem 'govuk_template', '~> 0.23.3'
gem 'gov_uk_date_fields', '~> 3.0.0'
gem 'jquery-rails'
gem 'pg', '~> 1.0.0'
gem 'puma', '~> 3.0'
gem 'rails', '~> 5.1.6'
gem 'responders'
gem 'sass-rails'
gem 'sentry-raven'
gem 'uglifier'
gem 'uk_postcode'
gem 'virtus'

# PDF generation
gem 'combine_pdf', '~> 1.0.10'
gem 'wicked_pdf', '~> 1.1.0'
gem 'wkhtmltopdf-binary'

group :production do
  gem 'lograge'
  gem 'logstash-event'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'faker'
  gem 'i18n-debug'
  gem 'letter_opener'
  gem 'listen'
  gem 'ministryofjustice-danger'
  gem 'web-console'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'dotenv-rails'
  gem 'launchy'
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
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'phantomjs'
  gem 'rails-controller-testing'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov', require: false
  gem 'simplecov-rcov'
  gem 'webmock'
end
