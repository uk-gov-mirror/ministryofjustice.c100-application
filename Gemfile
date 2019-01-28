source 'https://rubygems.org'

ruby '2.5.1'

gem 'devise', '~> 4.4.3'
gem 'email_validator'
gem 'govuk_elements_form_builder', '~> 1.3.0'
gem 'govuk_elements_rails', '~> 3.0'
gem 'govuk_frontend_toolkit', '< 8.0.0'
gem 'govuk_notify_rails', '~> 2.1.0'
gem 'govuk_template', '~> 0.23.3'
gem 'gov_uk_date_fields', '~> 3.1.0'
gem 'jquery-rails'
gem 'pg', '~> 1.0.0'
gem 'puma', '~> 3.0'
gem 'puma_worker_killer'
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
  # Warning: `mutant` is locked to this version, as newer ones implement some extra
  # mutations that make form object tests fail (maybe others). Upgrading the version
  # will require some effort to neutralise new mutants and to ensure CI runs flawless.
  gem 'mutant', '0.8.14'
  gem 'mutant-rspec', '0.8.14'
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
