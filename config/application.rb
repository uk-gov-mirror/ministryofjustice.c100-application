require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

class Application < Rails::Application
  config.load_defaults 5.2

  # We use the callback manually in the controllers that require it
  config.action_controller.default_protect_from_forgery = false

  # This automatically adds id: :uuid to create_table in all future migrations
  config.generators do |g|
    g.orm :active_record, primary_key_type: :uuid
  end

  config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml')]

  config.action_mailer.default_url_options = { host: ENV.fetch('EXTERNAL_URL') }

  # Don't generate system test files.
  config.generators.system_tests = nil

  # By default we use `sidekiq` but can be overridden with the ENV variable,
  # for example to use `async` or `inline`.
  # In development most of the time can be left as `async`, otherwise you need
  # to run redis and sidekiq in the background to process the jobs.
  #
  config.active_job.queue_adapter = ENV.fetch('QUEUE_ADAPTER', :sidekiq).to_sym

  # We are using our own url-shortener. These short urls redirect to surveymonkey,
  # and tracks visits, so we can see if they are being used.
  config.surveys = {
    success: 'https://c100.service.justice.gov.uk/survey',
    kickout: 'https://c100.service.justice.gov.uk/exit_survey',
  }

  # This is the GDS-hosted homepage for our service, and the one with a `start` button
  config.gds_service_homepage_url = '/'.freeze  # TODO: replace this with the correct gov.uk URL, when we have one

  # Load the templates set (refer to `config/govuk_notify_templates.yml` for details)
  config.govuk_notify_templates = config_for(
    :govuk_notify_templates, env: ENV.fetch('GOVUK_NOTIFY_ENV', 'integration')
  ).symbolize_keys

  config.x.session.expires_in_minutes = ENV.fetch('SESSION_EXPIRES_IN_MINUTES', 60).to_i
  config.x.session.warning_when_remaining = ENV.fetch('SESSION_WARNING_WHEN_REMAINING', 5).to_i

  # As part of the postcode screening, an empty C100Application record is created.
  # If the postcode is not eligible, these records are left orphans and have no use.
  # We will only leave them for some time. Can be configured here.
  config.x.orphans.expire_in_days = 2

  # We maintain C100 applications for this number of days, regardless of their status,
  # and if it has an owner (it was saved for later), we send up to two email reminders
  # before we delete the application. If you change this number make sure to also update
  # `app/services/c100_app/reminder_rule_set.rb` and the Notify email templates.
  config.x.drafts.expire_in_days = 28

  # When a user is purged, any saved C100 applications belonging to them, are also purged.
  config.x.users.expire_in_days = 30

  # Applicant confirmation email, and court email, are sent via Notify, but Notify has a
  # very limited retention period. We maintain an audit (with no personal details) of the
  # delivery result of these emails for diagnostic and debug purposes.
  config.x.email_submissions_audit.expire_in_days = 90
end
