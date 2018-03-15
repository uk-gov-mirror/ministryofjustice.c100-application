class ApplicationController < ActionController::Base
  include ErrorHandling

  # :nocov:
  if ENV.fetch('HTTP_AUTH_ENABLED', false)
    http_basic_authenticate_with name: ENV.fetch('HTTP_AUTH_USER'), password: ENV.fetch('HTTP_AUTH_PASSWORD')
  end
  # :nocov:

  # This is required to get request attributes in to the production logs.
  # See the various lograge configurations in `production.rb`.
  def append_info_to_payload(payload)
    super
    payload[:referrer] = request&.referrer
    payload[:session_id] = request&.session&.id
    payload[:user_agent] = request&.user_agent
  end

  helper_method :current_c100_application

  def current_c100_application
    @_current_c100_application ||= C100Application.find_by_id(session[:c100_application_id])
  end

  private

  def reset_c100_application_session
    session.delete(:c100_application_id)
  end

  def initialize_c100_application(attributes = {})
    C100Application.create(attributes).tap do |c100_application|
      session[:c100_application_id] = c100_application.id
    end
  end
end
