module C100App
  class SendApplicationToCourt
    attr_reader :c100_application
    attr_reader :pdf_content

    def initialize(c100_application)
      @c100_application = c100_application
    end

    def process
      generate_pdf && send_emails
    end

    private

    def generate_pdf
      presenter = Summary::PdfPresenter.new(c100_application)
      presenter.generate

      @pdf_content = presenter.to_pdf
    end

    def send_emails
      Tempfile.create do |tmpfile|
        File.binwrite(tmpfile, pdf_content)

        # Now we have the PDF in the local filesystem, we can
        # create an EmailSubmission record, and send! it
        # to send PDF by email to the court, including
        # a user copy if they requested it.
        email_submission = EmailSubmission.create!(c100_application: c100_application)
        email_submission.send!(tmpfile)
      end
    end
  end
end
