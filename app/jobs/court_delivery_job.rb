class CourtDeliveryJob < ApplicationJob
  queue_as :court_submissions

  # As this is the email to the court, any exception during the processing
  # or sending of the PDF must be captured and notified to the applicant, if
  # they entered a receipt email.
  # This will allow us some time to debug and understand what went wrong.
  #
  rescue_from StandardError, with: :log_and_notify_error

  def perform(c100_application)
    C100App::CourtOnlineSubmission.new(c100_application).process
  end

  private

  def log_and_notify_error(exception)
    # arguments[0] refers to the first argument passed to the `perform` method
    c100_application = arguments[0]

    if c100_application.receipt_email.present?
      NotifyMailer.submission_error(c100_application).deliver_later
    end

    Raven.extra_context(c100_application_id: c100_application.id)
    Raven.capture_exception(exception)
  end
end
