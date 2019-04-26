module C100App
  class ApplicantOnlineSubmission
    attr_reader :c100_application
    attr_reader :pdf_content

    def initialize(c100_application)
      @c100_application = c100_application
    end

    def to_address
      c100_application.receipt_email
    end

    # Any exception in this method will bubble up to the Job classes
    def process
      generate_pdf && deliver_email && audit_data
    end

    private

    def generate_pdf
      presenter = Summary::PdfPresenter.new(c100_application)
      presenter.generate

      @pdf_content = StringIO.new(presenter.to_pdf)
    end

    def deliver_email
      NotifySubmissionMailer.with(application_details).application_to_user(
        to_address: to_address
      ).deliver_now
    end

    def audit_data
      c100_application.email_submission.update(
        email_copy_to: to_address, user_copy_sent_at: Time.current
      )
    end

    def application_details
      {
        c100_application: c100_application,
        c100_pdf: pdf_content,
      }
    end
  end
end
