require 'rails_helper'

RSpec.describe C100App::OnlinePayments do
  let(:payment_id) { 12345 }

  let(:payment_intent) {
    instance_double(
      PaymentIntent,
      state: {},
      status: 'ready',
      c100_application: c100_application,
      payment_id: payment_id,
      return_url: 'https://c100.justice.uk',
    )
  }

  let(:c100_application) {
    C100Application.new(
      id: '449362af-0bc3-4953-82a7-1363d479b876',
      created_at: Time.at(0),
      updated_at: Time.at(100),
      receipt_email: 'applicant@test.com',
    )
  }

  describe 'STATUSES_ENUM_MAP' do
    context 'maps API statuses to our internal statuses' do
      it 'maps success status' do
        expect(described_class::STATUSES_ENUM_MAP[:success]).to match_array(%w[success])
      end

      it 'maps pending status' do
        expect(described_class::STATUSES_ENUM_MAP[:pending]).to match_array(%w[started submitted capturable])
      end

      it 'maps failed status' do
        expect(described_class::STATUSES_ENUM_MAP[:failed]).to match_array(%w[failed cancelled error])
      end
    end
  end

  describe 'NON_RETRYABLE_CODES' do
    it 'returns the expected codes' do
      expect(described_class::NON_RETRYABLE_CODES).to match_array(%w[P0030 P0050])
    end
  end

  describe '.create_payment' do
    subject(:do_request) { described_class.create_payment(payment_intent) }

    let(:court_double) { double('Court', name: 'Test court', email: 'court@example.com') }
    let(:response_double) {
      double(call: double(
        'Response', payment_id: payment_id, status: status, state: { foo: 'bar' }, payment_url: 'https://payments.example.com'
      ))
    }

    let(:payload) do
      {
        amount: 215_00,
        description: 'Court fee for lodging a C100 application',
        return_url: 'https://c100.justice.uk',
        reference: '1970/01/449362AF',
        email: 'applicant@test.com',
        metadata: {
          court_gbs_code: 'TBD',
          court_name: 'Test court',
          court_email: 'court@example.com',
        }
      }
    end

    before do
      allow(c100_application).to receive(:screener_answers_court).and_return(court_double)

      allow(
        PaymentsApi::Requests::CreateCardPayment
      ).to receive(:new).with(payload).and_return(response_double)
    end

    context 'payment intent' do
      let(:status) { 'created' }

      it 'updates the payment intent' do
        expect(
          payment_intent
        ).to receive(:update).with(payment_id: payment_id, status: :created, state: { foo: 'bar' })

        expect(do_request.payment_url).to eq('https://payments.example.com')
      end

      # mutant killer
      context 'for statuses other than created' do
        context 'pending statuses' do
          let(:status) { 'submitted' }
          it { expect(payment_intent).to receive(:update).with(hash_including(status: :pending)); do_request }
        end

        context 'success statuses' do
          let(:status) { 'success' }
          it { expect(payment_intent).to receive(:update).with(hash_including(status: :success)); do_request }
        end

        context 'failed statuses' do
          let(:status) { 'cancelled' }
          it { expect(payment_intent).to receive(:update).with(hash_including(status: :failed)); do_request }
        end

        context 'for an unknown status' do
          let(:status) { 'weird_status' }

          it 'propagates the status, without mapping it' do
            expect(payment_intent).to receive(:update).with(hash_including(status: status))
            do_request
          end
        end
      end
    end
  end

  describe '.retrieve_payment' do
    subject(:do_request) { described_class.retrieve_payment(payment_intent) }

    let(:response_double) {
      double(call: double('Response', payment_id: payment_id, status: 'success', state: { foo: 'bar' }))
    }

    before do
      allow(
        PaymentsApi::Requests::GetCardPayment
      ).to receive(:new).with(payment_id: payment_id).and_return(response_double)

      allow(payment_intent).to receive(:update)
    end

    context 'payment details response' do
      it 'returns the response' do
        expect(do_request.status).to eq('success')
      end
    end

    context 'payment intent' do
      it 'updates the payment intent' do
        expect(
          payment_intent
        ).to receive(:update).with(payment_id: payment_id, status: :success, state: { foo: 'bar' })

        expect(do_request).not_to be_nil
      end
    end
  end

  describe '.non_retryable_state?' do
    let(:payment_intent) { instance_double(PaymentIntent, state: { 'code' => state_code }) }

    context 'non-retryable state code' do
      let(:state_code) { 'P0030' }

      it 'returns true for a non-retryable state code' do
        expect(described_class.non_retryable_state?(payment_intent)).to eq(true)
      end
    end

    context 'any other state code' do
      let(:state_code) { 'P0010' }

      it 'returns false for any other state code' do
        expect(described_class.non_retryable_state?(payment_intent)).to eq(false)
      end
    end
  end
end
