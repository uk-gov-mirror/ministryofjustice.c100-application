require 'rails_helper'

RSpec.describe PaymentIntent, type: :model do
  subject { described_class.new(c100_application: c100_application) }

  let(:c100_application) { C100Application.new }

  describe '#return_url' do
    let(:nonce) { '123456' }

    before do
      subject.save
      allow(SecureRandom).to receive(:hex).with(8).and_return(nonce)
    end

    after do
      subject.destroy
    end

    it 'sets the nonce' do
      expect {
        subject.return_url
      }.to change { subject.nonce }.from(nil).to(nonce)
    end

    it 'returns the url with the nonce parameter' do
      expect(
        subject.return_url
      ).to eq("https://c100.justice.uk/payments/#{subject.id}/validate?nonce=#{nonce}")
    end
  end

  describe '#revoke_nonce!' do
    it 'sets to nil the nonce, invalidating it' do
      expect(subject).to receive(:update_column).with(:nonce, nil)
      subject.revoke_nonce!
    end
  end
end
