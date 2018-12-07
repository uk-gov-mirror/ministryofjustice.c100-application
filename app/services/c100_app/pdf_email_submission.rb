module C100App
  class PdfEmailSubmission
    attr_reader :c100_application
    attr_reader :pdf_file

    def initialize(c100_application, pdf_file:)
      @c100_application = c100_application
      @pdf_file = pdf_file
    end

    def deliver!
      submission_to_court
      send_copy_to_user if receipt_address.present?
    end

    # This is the audit table where details about the emails are stored
    def email_submission
      c100_application.email_submission || c100_application.create_email_submission
    end

    # TODO: temporary feature-flag until we decide about Notify attachments
    def use_notify?
      Rails.env.development? || ENV.key?('DEV_TOOLS_ENABLED')
    end

    private

    def receipt_address
      c100_application.receipt_email
    end

    def court_address
      c100_application.screener_answers_court.email
    end

    def submission_to_court
      return if email_submission.sent_at.present?

      # TODO: temporary feature-flag until we decide about Notify attachments
      if use_notify?
        NotifySubmissionMailer.with(application_details).application_to_court(
          to_address: court_address
        ).deliver_now
      else
        CourtMailer.with(application_details).submission_to_court(
          to: court_address,
        ).deliver_now
      end

      audit_data(to_address: court_address, sent_at: Time.current)
    end

    def send_copy_to_user
      return if email_submission.user_copy_sent_at.present?

      # TODO: temporary feature-flag until we decide about Notify attachments
      if use_notify?
        NotifySubmissionMailer.with(application_details).application_to_user(
          to_address: receipt_address
        ).deliver_now
      else
        # if the user hits reply, it should go to the court
        ReceiptMailer.with(application_details).copy_to_user(
          to: receipt_address, reply_to: court_address,
        ).deliver_now
      end

      audit_data(email_copy_to: receipt_address, user_copy_sent_at: Time.current)
    end

    def application_details
      {
        c100_application: c100_application,
        c100_pdf: pdf_file,
      }
    end

    def audit_data(data)
      email_submission.update(data)
    end
  end
end
