class SubmissionMailerPreview < ActionMailer::Preview
  MOCK_PDF_PATH = Rails.root.join('app', 'assets', 'docs', 'c100_mock.pdf').freeze

  def submission_to_court
    CourtMailer.with(
      application_details
    ).submission_to_court(to: 'court@example.com')
  end

  def copy_to_user
    ReceiptMailer.with(
      application_details
    ).copy_to_user(to: 'user@example.com', reply_to: 'court@example.com')
  end

  private

  # We don't have a factory, so just building (not need to persist)
  # a bare minimum C100 application struct for the purpose of the preview
  def c100_application
    Struct.new(
      :reference_code,
      :urgent_hearing,
      :confidentiality_enabled?,
      :screener_answers_court,
      :applicants,
    ).new(
      '12345',
      'no',
      true,
      local_court_fixture,
      applicants_fixture,
    )
  end

  def application_details
    {
      c100_application: c100_application,
      c100_pdf: MOCK_PDF_PATH,
    }
  end

  def applicants_fixture
    [Applicant.new(full_name: 'John Doe')]
  end

  def local_court_fixture
    Court.new(
      "address" => {
        "address_lines" => ["351 Silbury Boulevard", "Witan Gate East"],
        "town" => "Central Milton Keynes",
        "postcode" => "MK9 2DT",
      },
      "name" => "Milton Keynes County Court and Family Court",
      "slug" => "milton-keynes-county-court-and-family-court",
      "email" => "family@miltonkeynes.countycourt.gsi.gov.uk",
    )
  end
end
