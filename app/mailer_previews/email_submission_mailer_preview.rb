
class EmailSubmissionMailerPreview < ActionMailer::Preview
  DEFAULT_PDF_PATH='/tmp/c100-preview.pdf'.freeze

  def submission_to_court
    path = write_tmp_pdf
    EmailSubmissionMailer.submission_to_court(default_args(path))
  end

  def copy_to_user
    path = write_tmp_pdf
    EmailSubmissionMailer.copy_to_user(default_args(path))
  end

  private

  def generate_pdf
    presenter = Summary::PdfPresenter.new(c100_application)
    presenter.generate

    @pdf_content ||= presenter.to_pdf
  end

  def write_tmp_pdf
    path = DEFAULT_PDF_PATH
    File.open(path, 'wb') do |f|
      f << generate_pdf
    end
    path
  end

  def c100_application
    @c100 ||= C100Application.last
  end

  def default_args(pdf_file_path)
    {
      c100_application: c100_application,
      from: 'from-address-here@example.com',
      to: 'to-address-here@example.com',
      reply_to: 'reply-to-here@example.com',
      attachment: pdf_file_path
    }
  end
end
