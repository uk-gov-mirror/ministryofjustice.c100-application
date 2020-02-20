# Will use SENTRY_DSN environment variable if set
# :nocov:
Raven.configure do |config|
  config.environments = %w( production )
  config.silence_ready = true

  # Convert to regex, otherwise Sentry will threat them as words
  # https://github.com/getsentry/raven-ruby/blob/master/lib/raven/processor/sanitizedata.rb
  config.sanitize_fields = Rails.application.config.filter_parameters.map { |w| "#{w}+" }
end
# :nocov:
