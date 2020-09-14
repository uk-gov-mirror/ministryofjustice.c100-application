require 'spec_helper'

RSpec.describe ValidPaymentsArray do
  subject { described_class.new(c100_application) }

  let(:c100_application) { C100Application.new(attributes) }
  let(:attributes) { {
    has_solicitor: has_solicitor,
    submission_type: submission_type,
  } }

  let(:has_solicitor) { nil }
  let(:submission_type) { nil }

  let(:common_choices) { described_class::COMMON_CHOICES }

  describe '#pay_blocklist' do
    it 'returns the blocked slugs' do
      expect(
        subject.pay_blocklist
      ).to match_array(%w(
        blocklisted-slug-example

        york-county-court-and-family-court
        barrow-in-furness-county-court-and-family-court
        liverpool-civil-and-family-court

        canterbury-combined-court-centre
        carmarthen-county-court-and-family-court
        chester-civil-and-family-justice-centre
        clerkenwell-and-shoreditch-county-court-and-family-court
        crewe-county-court-and-family-court
        dartford-county-court-and-family-court
        dudley-county-court-and-family-court
        haverfordwest-county-court-and-family-court
        hertford-county-court-and-family-court
        isle-of-wight-combined-court
        maidstone-combined-court-centre
        staines-county-court-and-family-court
        thanet-county-court-and-family-court
        torquay-and-newton-abbot-county-court-and-family-court
        uxbridge-county-court-and-family-court
        weymouth-combined-court
        yeovil-county-family-and-magistrates-court
      ))
    end
  end

  describe '#include?' do
    context 'for an included string' do
      it 'returns true' do
        expect(subject.include?(PaymentType::HELP_WITH_FEES.to_s)).to eq(true)
      end
    end

    context 'for an included value-object' do
      it 'returns true' do
        expect(subject.include?(PaymentType::HELP_WITH_FEES)).to eq(true)
      end
    end

    context 'for an invalid string' do
      it 'returns true' do
        expect(subject.include?('foobar')).to eq(false)
      end
    end

    context 'for a nil value' do
      it 'returns false' do
        expect(subject.include?(nil)).to eq(false)
      end
    end
  end

  context 'for an online submission' do
    let(:submission_type) { SubmissionType::ONLINE.to_s }

    let(:court_double) { Court.new(court_data) }
    let(:court_data) {
      {
        'name' => 'Test court',
        'email' => 'court@example.com',
        'address' => 'Court address',
        'slug' => court_slug,
        'gbs' => court_gbs,
      }
    }

    let(:court_gbs) { 'XYZ' }
    let(:court_slug) { 'west-london-family-court' }

    before do
      allow(c100_application).to receive(:screener_answers_court).and_return(court_double)
    end

    context 'for a court slug included in the blocklist' do
      let(:court_slug) { 'blocklisted-slug-example' }

      it 'does not include the online option' do
        expect(subject).not_to include(PaymentType::ONLINE)
      end

      it 'includes the pay by phone option' do
        expect(subject).to include(PaymentType::SELF_PAYMENT_CARD)
      end
    end

    context 'for a court without GBS code' do
      let(:court_gbs) { Court::UNKNOWN_GBS }

      it 'does not include the online option' do
        expect(subject).not_to include(PaymentType::ONLINE)
      end

      it 'includes the pay by phone option' do
        expect(subject).to include(PaymentType::SELF_PAYMENT_CARD)
      end
    end

    context 'with solicitor' do
      let(:has_solicitor) { 'yes' }

      it 'has valid payment choices' do
        expect(subject).to match_array(common_choices + [PaymentType::SOLICITOR, PaymentType::ONLINE])
      end
    end

    context 'without solicitor' do
      let(:has_solicitor) { 'no' }

      it 'has valid payment choices' do
        expect(subject).to match_array(common_choices + [PaymentType::ONLINE])
      end
    end
  end

  context 'for a print and post submission' do
    let(:submission_type) { SubmissionType::PRINT_AND_POST.to_s }

    it 'does not include the pay by phone option' do
      expect(subject).not_to include(PaymentType::SELF_PAYMENT_CARD)
    end

    context 'with solicitor' do
      let(:has_solicitor) { 'yes' }

      it 'has valid payment choices' do
        expect(subject).to match_array(common_choices + [PaymentType::SOLICITOR])
      end
    end

    context 'without solicitor' do
      let(:has_solicitor) { 'no' }

      it 'has valid payment choices' do
        expect(subject).to match_array(common_choices)
      end
    end
  end
end
