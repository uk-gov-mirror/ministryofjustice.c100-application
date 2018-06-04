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
  # a bare minimum C100 application struct for the purpose of the preview
  def c100_application
    Struct.new(:reference_code, :screener_answers_court).new(
      '12345',
      local_court_fixture,
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

  def local_court_fixture
    Court.new.from_courtfinder_data!(
      "address_lines" => ["351 Silbury Boulevard", "Witan Gate East"],
      "town" => "Central Milton Keynes",
      "postcode" => "MK9 2DT",
      "name" => "Milton Keynes County Court and Family Court",
      "slug" => "milton-keynes-county-court-and-family-court",
      "phone_number" => 388,
      "email" => "family@miltonkeynes.countycourt.gsi.gov.uk",
      "opening_times" =>
        [
          "Bailiff telephone service: For payments only Tel: 01865 264200 (option 1 then option 7)",
          "Court counter open: by prior appointment only",
          "Court building open: Monday to Friday 8:30am to 4pm",
          "Telephone Enquiries from: 9am to 5pm"
        ]
    )
  end
end
