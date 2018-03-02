require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Ensure that when running the application through Rake the RAILS_ENV doesn't incorrectly
# get replaced with 'development' when running the specs.
# Adapted from `railties/lib/rails/test_unit/railtie.rb`.
# :nocov:
if defined?(Rake.application) &&
    Rake.application.top_level_tasks.grep(/^(default$|spec(:|$))/).any?
  ENV["RAILS_ENV"] ||= "test"
end
# :nocov:

Bundler.require *Rails.groups(assets: %w(development test))

class Application < Rails::Application
  ActionView::Base.default_form_builder = GovukElementsFormBuilder::FormBuilder

  # This automatically adds id: :uuid to create_table in all future migrations
  config.generators do |g|
    g.orm :active_record, primary_key_type: :uuid
  end

  config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml')]

  config.survey_link = 'https://www.gov.uk/done/c100'.freeze
  config.kickout_survey_link = 'REPLACEME'.freeze

  # This is the GDS-hosted homepage for our service, and the one with a `start` button
  config.gds_service_homepage_url = '/'.freeze  # TODO: replace this with the correct gov.uk URL, when we have one

  # Load the templates set (refer to `config/govuk_notify_templates.yml` for details)
  config.govuk_notify_templates = config_for(
    :govuk_notify_templates, env: ENV.fetch('GOVUK_NOTIFY_ENV', 'integration')
  ).symbolize_keys

  config.x.session.expires_in_minutes = ENV.fetch('SESSION_EXPIRES_IN_MINUTES', 30).to_i
  config.x.session.warning_when_remaining = ENV.fetch('SESSION_WARNING_WHEN_REMAINING', 5).to_i

  config.x.drafts.expire_in_days = ENV.fetch('EXPIRE_AFTER', 14).to_i
  config.x.users.expire_in_days = ENV.fetch('USERS_EXPIRE_AFTER', 30).to_i

  config.action_mailer.default_url_options = {host: ENV.fetch('EXTERNAL_URL')}
end
