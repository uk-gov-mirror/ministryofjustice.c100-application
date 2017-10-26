Rails.application.config.session_store :cookie_store,
  key:          '_c100_application_session',
  expire_after: Rails.configuration.x.session.expires_in_minutes.minutes
