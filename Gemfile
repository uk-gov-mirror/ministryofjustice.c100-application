source 'https://rubygems.org'

ruby '2.6.2'

gem 'devise', '~> 4.7.1'
gem 'email_validator'
gem 'govuk_elements_form_builder', git: "https://github.com/ministryofjustice/govuk_elements_form_builder.git"
gem 'govuk_elements_rails', '~> 3.0'
gem 'govuk_frontend_toolkit', '< 8.0.0'
gem 'govuk_notify_rails', '~> 2.1.0'
gem 'govuk_template', '~> 0.23.3'
gem 'gov_uk_date_fields', '~> 3.1.0'
gem 'jquery-rails'
gem 'omniauth-auth0', '~> 2.2'
gem 'omniauth-rails_csrf_protection'
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
gem 'combine_pdf', '~> 1.0'
gem 'wicked_pdf', '~> 1.1.0'
gem 'wkhtmltopdf-binary', '0.12.3.1'

group :production do
  gem 'lograge'
  gem 'logstash-event'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'i18n-debug'
  gem 'letter_opener'
  gem 'web-console'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'launchy'
  gem 'mutant'
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
  gem 'poltergeist'
  gem 'phantomjs'
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter'
  gem 'rubocop', '~> 0.52.1', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov', require: false
  gem 'simplecov-rcov'
  gem 'webmock'
end
