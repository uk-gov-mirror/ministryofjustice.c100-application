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
