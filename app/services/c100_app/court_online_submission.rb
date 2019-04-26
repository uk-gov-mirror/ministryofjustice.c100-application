module C100App
  class CourtOnlineSubmission
    attr_reader :c100_application
    attr_reader :pdf_content

    def initialize(c100_application)
      @c100_application = c100_application
    end

    def to_address
      c100_application.screener_answers_court.email
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
      NotifySubmissionMailer.with(application_details).application_to_court(
        to_address: to_address
      ).deliver_now
    end

    def audit_data
      c100_application.email_submission.update(
        to_address: to_address, sent_at: Time.current
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
