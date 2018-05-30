class SendApplicationToCourtJob < ApplicationJob
  queue_as :default

  attr_reader :c100_application
  attr_reader :pdf_content

  def perform(c100_application)
    @c100_application = c100_application

    generate_pdf && send_email
  end

  private

  def generate_pdf
    presenter = Summary::PdfPresenter.new(c100_application)
    presenter.generate

    @pdf_content = presenter.to_pdf
  end

  def send_email
    Tempfile.create('tmpfile') do |tmpfile|
      File.binwrite(tmpfile, pdf_content)

      # Now we have the PDF in the local filesystem, we can
      # create an EmailSubmission record, and send! it
      # to send PDF by email to the court, including
      # a user copy if they requested it.
      es = EmailSubmission.create!(c100_application: c100_application)
      es.send!(tmpfile)
    end
  end
end
