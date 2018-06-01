class SubmissionMailerPreview < ActionMailer::Preview
  MOCK_PDF_PATH = Rails.root.join('app', 'assets', 'docs', 'c100_mock.pdf').freeze

  def submission_to_court
    CourtMailer.with(
      application_details
    ).submission_to_court(recipients)
  end

  def copy_to_user
    ReceiptMailer.with(
      application_details
    ).copy_to_user(recipients)
  end

  private

  # We don't have a factory, so just building (not need to persist)
  # a bare minimum C100 application for the purpose of the preview
  def c100_application
    C100Application.new(
      id: '35fe21a6-93f2-42e0-9189-22c99866ca89',
      created_at: Time.now.utc,
    )
  end

  def application_details
    {
      c100_application: c100_application,
      c100_pdf: MOCK_PDF_PATH,
    }
  end

  def recipients
    {
      to: 'to-address@example.com',
      reply_to: 'reply-to@example.com',
    }
  end
end
