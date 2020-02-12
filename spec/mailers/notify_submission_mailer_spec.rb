require 'spec_helper'

RSpec.describe NotifySubmissionMailer, type: :mailer do
  let(:c100_application) {
    C100Application.new(
      id: '4a362e1c-48eb-40e3-9458-a31ead3f30a4',
      created_at: Time.at(0),
      receipt_email: 'receipt@example.com',
      urgent_hearing: 'yes',
      address_confidentiality: address_confidentiality,
      payment_type: payment_type,
      declaration_signee: 'John Doe',
    )
  }

  let(:payment_type) { nil }
  let(:address_confidentiality) { 'no' }

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

    allow(I18n).to receive(:translate!).with('service.name').and_return(
      'Apply to court about child arrangements'
    )
  end

  describe '#application_to_court' do
    let(:documents) { { bundle: StringIO.new('bundle pdf'), c8_form: c8_form } }
    let(:c8_form) { StringIO.new('') }

    let(:mail) {
      described_class.with(
        c100_application: c100_application, documents: documents
      ).application_to_court(to_address: 'court@example.com')
    }

    it_behaves_like 'a Notify mail', template_id: 'application_submitted_to_court_template_id'

    it { expect(mail.to).to eq(['court@example.com']) }
    it { expect(mail.from).to eq(['receipt@example.com']) }

    it 'has the right reference' do
      expect(mail.govuk_notify_reference).to eq('court;1970/01/4A362E1C')
    end

    it 'has the right personalisation' do
      expect(mail.govuk_notify_personalisation).to eq({
        service_name: 'Apply to court about child arrangements',
        applicant_name: 'John Doe',
        reference_code: '1970/01/4A362E1C',
        urgent: 'yes',
        c8_included: 'no',
        link_to_c8_pdf: '',
        link_to_pdf: { file: 'YnVuZGxlIHBkZg==' },
      })
    end

    context 'and applicant triggered the `address confidentiality`' do
      let(:address_confidentiality) { 'yes' }
      let(:c8_form) { StringIO.new('c8 form') }

      it 'has the right personalisation' do
        expect(
          mail.govuk_notify_personalisation
        ).to match(hash_including(
          c8_included: 'yes',
          link_to_c8_pdf: { file: 'YzggZm9ybQ==' },
          link_to_pdf: { file: 'YnVuZGxlIHBkZg==' },
        ))
      end
    end
  end

  describe '#application_to_user' do
    before do
      allow(c100_application).to receive(:screener_answers_court).and_return(court)

      allow(I18n).to receive(:translate!).with(
        PaymentType::SELF_PAYMENT_CARD, scope: [:notify_submission_mailer, :payment_instructions]
      ).and_return('payment instructions from locales')
    end

    let(:documents) { {bundle: StringIO.new('bundle pdf')} }

    let(:mail) {
      described_class.with(
        c100_application: c100_application, documents: documents
      ).application_to_user(to_address: 'user@example.com')
    }

    it_behaves_like 'a Notify mail', template_id: 'application_submitted_to_user_template_id'

    it { expect(mail.to).to eq(['user@example.com']) }
    it { expect(mail.from).to eq(['receipt@example.com']) }

    it 'has the right reference' do
      expect(mail.govuk_notify_reference).to eq('user;1970/01/4A362E1C')
    end

    it 'has the right personalisation' do
      expect(mail.govuk_notify_personalisation).to eq({
        service_name: 'Apply to court about child arrangements',
        applicant_name: 'John Doe',
        reference_code: '1970/01/4A362E1C',
        court_name: 'Test court',
        court_email: 'court@example.com',
        court_url: 'https://courttribunalfinder.service.gov.uk/courts/test-court',
        payment_instructions: 'payment instructions from locales',
        link_to_pdf: { file: 'YnVuZGxlIHBkZg==' },
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
