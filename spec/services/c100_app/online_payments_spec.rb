require 'rails_helper'

RSpec.describe C100App::OnlinePayments do
  subject { described_class.new(c100_application) }

  let(:c100_application) {
    C100Application.new(
      id: '449362af-0bc3-4953-82a7-1363d479b876',
      created_at: Time.at(0),
      updated_at: Time.at(100),
      receipt_email: 'applicant@test.com',
    )
  }

  describe '#payment_url' do
    let(:response_double) { double(call: double(payment_url: 'http://example.com')) }
    let(:payload) do
      {
        amount: 215_00,
        reference: '1970/01/449362AF',
        return_url: 'https://c100.justice.uk/steps/completion/confirmation',
        description: 'Court fee for lodging a C100 application',
        email: 'applicant@test.com',
      }
    end

    before do
      allow(
        PaymentsApi::Requests::CreateCardPayment
      ).to receive(:new).with(payload).and_return(response_double)
    end

    it 'returns the URL where to redirect the user to take payment' do
      expect(subject.payment_url).to eq('http://example.com')
    end
  end
end
