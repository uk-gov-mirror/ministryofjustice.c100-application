module C100App
  class OnlineSubmission
    attr_reader :c100_application
    attr_reader :pdf_content
    attr_reader :recipient

    def initialize(c100_application, recipient:)
      @c100_application = c100_application
      @recipient = recipient
    end

    # Any exception in this method will bubble up to the Job classes
    def process
      generate_pdf && deliver_email
    end

    private

    def generate_pdf
      presenter = Summary::PdfPresenter.new(c100_application)
      presenter.generate

      @pdf_content = StringIO.new(presenter.to_pdf)
    end

    def deliver_email
      PdfEmailSubmission.new(
        c100_application, pdf_content: pdf_content
      ).deliver!(recipient)
    end
  end
end
