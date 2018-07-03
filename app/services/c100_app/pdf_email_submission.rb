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

    private

    def receipt_address
      c100_application.receipt_email
    end

    def court_address
      c100_application.screener_answers_court.email
    end

    def submission_to_court
      return unless email_submission.message_id.nil?

      response = CourtMailer.with(application_details).submission_to_court(
        to: court_address,
      ).deliver_now!

      audit_data(
        to_address: court_address,
        sent_at: Time.current,
        message_id: response.message_id,
      )
    end

    def send_copy_to_user
      return unless email_submission.user_copy_message_id.nil?

      # if the user hits reply, it should go to the court
      response = ReceiptMailer.with(application_details).copy_to_user(
        to: receipt_address,
        reply_to: court_address,
      ).deliver_now!

      audit_data(
        email_copy_to: receipt_address,
        user_copy_sent_at: Time.current,
        user_copy_message_id: response.message_id,
      )
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
