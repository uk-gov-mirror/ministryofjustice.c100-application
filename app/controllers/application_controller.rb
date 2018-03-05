class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Heroku demo app requires basic auth to restrict access
  # :nocov:
  if ENV.fetch('HEROKU_APP_NAME', false)
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

  rescue_from Exception do |exception|
    case exception
    when Errors::InvalidSession, ActionController::InvalidAuthenticityToken
      redirect_to invalid_session_errors_path
    when Errors::ApplicationNotFound
      redirect_to application_not_found_errors_path
    else
      raise if Rails.application.config.consider_all_requests_local

      Raven.capture_exception(exception)
      redirect_to unhandled_errors_path
    end
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

  def check_c100_application_presence
    raise Errors::InvalidSession unless current_c100_application
  end
end
