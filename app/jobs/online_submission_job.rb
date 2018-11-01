class OnlineSubmissionJob < ApplicationJob
  queue_as :submissions

  rescue_from StandardError, with: :log_and_notify_error

  def perform(c100_application)
    C100App::OnlineSubmission.new(c100_application).process
  end

  private

  def log_and_notify_error(exception)
    # arguments[0] refers to the first argument passed to the `perform` method
    c100_application = arguments[0]

    NotifyMailer.submission_error(c100_application).deliver_later if c100_application.receipt_email.present?

    Raven.extra_context(c100_application_id: c100_application.id)
    Raven.capture_exception(exception)
  end
end
