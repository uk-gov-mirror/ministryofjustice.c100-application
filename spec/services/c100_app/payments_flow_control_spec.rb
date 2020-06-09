require 'rails_helper'

RSpec.describe C100App::PaymentsFlowControl do
  subject { described_class.new(c100_application) }

  let(:c100_application) {
    C100Application.new(
      submission_type: submission_type,
      payment_type: payment_type,
      declaration_signee: declaration_signee,
    )
  }

  let(:submission_type) { SubmissionType::ONLINE }
  let(:payment_type) { PaymentType::SELF_PAYMENT_CARD }
  let(:declaration_signee) { 'John Doe' }

  let(:payment_intent) { PaymentIntent.new(status: intent_status) }
  let(:intent_status) { 'ready' }

  before do
    allow(
      PaymentIntent
    ).to receive(:find_or_create_by!).with(
      c100_application: c100_application
    ).and_return(payment_intent)
  end

  describe '#payment_url' do
    before do
      # We test the confirmation URL separately
      allow(subject).to receive(:confirmation_url).and_return('confirmation-page')
    end

    context 'when feature flag is not enabled' do
      let(:declaration_signee) { 'John FooBar' }

      it 'skips to confirmation' do
        expect(subject.payment_url).to eq('confirmation-page')
      end
    end

    context 'when feature flag is enabled' do
      context 'and payment is offline' do
        let(:payment_type) { PaymentType::HELP_WITH_FEES }

        it 'sets the payment_intent as finished and skips to confirmation' do
          expect(payment_intent).to receive(:finish!).with(with_status: :offline_type)
          expect(subject.payment_url).to eq('confirmation-page')
        end
      end

      context 'and payment is online' do
        it 'calls the API to create the payment' do
          expect(
            C100App::OnlinePayments
          ).to receive(:create_payment).with(payment_intent).and_return(
            double(payment_url: 'https://payments.example.com')
          )

          expect(subject.payment_url).to eq('https://payments.example.com')
        end
      end
    end

    context 'when there is an exception' do
      before do
        allow(
          C100App::OnlinePayments
        ).to receive(:create_payment).and_raise(ArgumentError.new('boom!'))
      end

      it 'bubbles up as a `PaymentUnexpectedError` exception' do
        expect {
          subject.payment_url
        }.to raise_error(Errors::PaymentUnexpectedError).with_message('boom!')
      end
    end
  end

  describe '#next_url' do
    before do
      # We test the confirmation URL separately
      allow(subject).to receive(:confirmation_url).and_return('confirmation-page')

      # We also test this separately
      expect(C100App::OnlinePayments).to receive(:retrieve_payment).with(payment_intent)
    end

    let(:payment_response) { nil }

    context 'for a success payment status' do
      let(:intent_status) { 'success' }

      it 'sets the payment_intent as finished and continue to confirmation' do
        expect(payment_intent).to receive(:finish!)
        expect(subject.next_url).to eq('confirmation-page')
      end
    end

    context 'for a failed payment status' do
      let(:intent_status) { 'failed' }

      it 'returns an error page' do
        expect(payment_intent).not_to receive(:finish!)
        expect(subject.next_url).to eq('/errors/payment_error')
      end
    end

    context 'when there is an exception' do
      before do
        allow(
          C100App::OnlinePayments
        ).to receive(:retrieve_payment).and_raise(ArgumentError.new('boom!'))
      end

      it 'bubbles up as a `PaymentUnexpectedError` exception' do
        expect {
          subject.next_url
        }.to raise_error(Errors::PaymentUnexpectedError).with_message('boom!')
      end
    end
  end

  describe '#confirmation_url' do
    let(:queue) { double.as_null_object }

    context 'for an online submission' do
      let(:submission_type) { SubmissionType::ONLINE }

      it 'process the application online submission and returns the confirmation page' do
        expect(C100App::OnlineSubmissionQueue).to receive(:new).with(c100_application).and_return(queue)

        expect(queue).to receive(:process)
        expect(subject.confirmation_url).to eq('/steps/completion/confirmation')
      end
    end

    context 'for a print and post submission' do
      let(:submission_type) { SubmissionType::PRINT_AND_POST }

      it 'returns the what next page' do
        expect(queue).not_to receive(:process)
        expect(subject.confirmation_url).to eq('/steps/completion/what_next')
      end
    end
  end
end
