module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from Exception do |exception|
      case exception
      when Errors::InvalidSession # , ActionController::InvalidAuthenticityToken
        redirect_to invalid_session_errors_path
      when Errors::ApplicationNotFound
        redirect_to application_not_found_errors_path
      when Errors::ApplicationScreening
        redirect_to application_screening_errors_path
      when Errors::ApplicationCompleted
        redirect_to application_completed_errors_path
      else
        raise if Rails.application.config.consider_all_requests_local

        Raven.capture_exception(exception)
        redirect_to unhandled_errors_path
      end
    end
  end

  private

  def check_c100_application_presence
    raise Errors::InvalidSession unless current_c100_application
  end

  def check_application_not_completed
    raise Errors::ApplicationCompleted if current_c100_application.completed?
  end

  def check_application_not_screening
    raise Errors::ApplicationScreening if current_c100_application.screening?
  end
end
