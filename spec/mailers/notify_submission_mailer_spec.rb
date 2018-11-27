require 'spec_helper'

RSpec.describe NotifySubmissionMailer, type: :mailer do
  let(:c100_application) {
    C100Application.new(
      id: '4a362e1c-48eb-40e3-9458-a31ead3f30a4',
      created_at: Time.at(0),
      receipt_email: 'receipt@example.com',
      urgent_hearing: 'yes',
      address_confidentiality: 'no',
      payment_type: payment_type,
    )
  }
  let(:c100_pdf) { Tempfile.new('test.pdf') }

  let(:payment_type) { nil }
  let(:court) {
    double('Court',
      name: 'Test court',
      email: 'court@example.com',
      slug: 'test-court'
    )
  }

  before do
    allow(
      Rails.configuration
    ).to receive(:govuk_notify_templates).and_return(
      application_submitted_to_court: 'application_submitted_to_court_template_id',
      application_submitted_to_user: 'application_submitted_to_user_template_id',
    )

    allow(c100_pdf).to receive(:read).and_return('file content')

    allow(I18n).to receive(:translate!).with('service.name').and_return(
      'Apply to court about child arrangements'
    )
  end

  describe '#application_to_court' do
    let(:mail) {
      described_class.with(
        c100_application: c100_application, c100_pdf: c100_pdf
      ).application_to_court(to_address: 'court@example.com')
    }

    it_behaves_like 'a Notify mail', template_id: 'application_submitted_to_court_template_id'

    it { expect(mail.to).to eq(['court@example.com']) }
    it { expect(mail.from).to eq(['receipt@example.com']) }

    it 'has the right personalisation' do
      expect(mail.govuk_notify_personalisation).to eq({
        service_name: 'Apply to court about child arrangements',
        applicant_name: '[name not entered]',
        reference_code: '1970/01/4A362E1C',
        urgent: 'yes',
        c8_included: 'no',
        link_to_pdf: { file: 'ZmlsZSBjb250ZW50' },
      })
    end
  end

  describe '#application_to_user' do
    before do
      allow(c100_application).to receive(:screener_answers_court).and_return(court)

      allow(I18n).to receive(:translate!).with(
        PaymentType::SELF_PAYMENT_CARD, scope: [:notify_submission_mailer, :payment_instructions]
      ).and_return('payment instructions from locales')
    end

    let(:mail) {
      described_class.with(
        c100_application: c100_application, c100_pdf: c100_pdf
      ).application_to_user(to_address: 'user@example.com')
    }

    it_behaves_like 'a Notify mail', template_id: 'application_submitted_to_user_template_id'

    it { expect(mail.to).to eq(['user@example.com']) }
    it { expect(mail.from).to eq(['receipt@example.com']) }

    it 'has the right personalisation' do
      expect(mail.govuk_notify_personalisation).to eq({
        service_name: 'Apply to court about child arrangements',
        applicant_name: '[name not entered]',
        reference_code: '1970/01/4A362E1C',
        court_name: 'Test court',
        court_email: 'court@example.com',
        court_url: 'https://courttribunalfinder.service.gov.uk/courts/test-court',
        payment_instructions: 'payment instructions from locales',
        link_to_pdf: { file: 'ZmlsZSBjb250ZW50' },
      })
    end

    context 'for a specific payment type' do
      before do
        allow(I18n).to receive(:translate!).with(
          'help_with_fees', scope: [:notify_submission_mailer, :payment_instructions]
        ).and_return('hwf payment instructions')
      end

      let(:payment_type) { 'help_with_fees' }

      it 'has the right personalisation' do
        expect(
          mail.govuk_notify_personalisation
        ).to include(payment_instructions: 'hwf payment instructions')
      end
    end
  end
end
