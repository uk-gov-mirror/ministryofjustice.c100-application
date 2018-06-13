require 'spec_helper'

RSpec.describe Steps::Application::PaymentForm do
  let(:arguments) { {
    c100_application: c100_application,
    payment_type: payment_type,
    hwf_reference_number: hwf_reference_number,
    solicitor_account_number: solicitor_account_number,
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:payment_type) { PaymentType::SELF_PAYMENT_CARD.to_s }
  let(:hwf_reference_number) { nil }
  let(:solicitor_account_number) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:payment_type, :inclusion) }

      it { should_not validate_presence_of(:hwf_reference_number) }
      it { should_not validate_presence_of(:solicitor_account_number) }

      context 'when payment type is `help_with_fees`' do
        let(:payment_type) { PaymentType::HELP_WITH_FEES.to_s }
        it { should validate_presence_of(:hwf_reference_number) }
      end

      context 'when payment type is `solicitor`' do
        let(:payment_type) { PaymentType::SOLICITOR.to_s }
        it { should validate_presence_of(:solicitor_account_number) }
      end
    end

    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'when form is valid' do
      let(:payment_type) { PaymentType::SELF_PAYMENT_CARD.to_s }
      let(:hwf_reference_number) { 'HWF-12345' }
      let(:solicitor_account_number) { 'SOL-12345' }

      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          payment_type: 'self_payment_card',
          hwf_reference_number: nil,
          solicitor_account_number: nil,
        ).and_return(true)

        expect(subject.save).to be(true)
      end

      context 'when payment type is `help_with_fees`' do
        let(:payment_type) { PaymentType::HELP_WITH_FEES.to_s }

        it 'saves the record' do
          expect(c100_application).to receive(:update).with(
            payment_type: 'help_with_fees',
            hwf_reference_number: 'HWF-12345',
            solicitor_account_number: nil,
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when payment type is `solicitor`' do
        let(:payment_type) { PaymentType::SOLICITOR.to_s }

        it 'saves the record' do
          expect(c100_application).to receive(:update).with(
            payment_type: 'solicitor',
            hwf_reference_number: nil,
            solicitor_account_number: 'SOL-12345',
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
