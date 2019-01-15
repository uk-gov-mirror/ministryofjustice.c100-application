module C100App
  class PdfEmailSubmission
    attr_reader :c100_application
    attr_reader :pdf_content

    def initialize(c100_application, pdf_content:)
      @c100_application = c100_application
      @pdf_content = pdf_content
    end

    def deliver!(recipient)
      case recipient
      when :court
        submission_to_court
      when :applicant
        send_copy_to_user
      end
    end

    private

    def receipt_address
      c100_application.receipt_email
    end

    def court_address
      c100_application.screener_answers_court.email
    end

    def submission_to_court
      NotifySubmissionMailer.with(application_details).application_to_court(
        to_address: court_address
      ).deliver_now

      audit_data(to_address: court_address, sent_at: Time.current)
    end

    def send_copy_to_user
      NotifySubmissionMailer.with(application_details).application_to_user(
        to_address: receipt_address
      ).deliver_now

      audit_data(email_copy_to: receipt_address, user_copy_sent_at: Time.current)
    end

    def application_details
      {
        c100_application: c100_application,
        c100_pdf: pdf_content,
      }
    end

    def audit_data(data)
      c100_application.email_submission.update(data)
    end
  end
end
