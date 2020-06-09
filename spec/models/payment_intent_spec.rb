require 'rails_helper'

RSpec.describe PaymentIntent, type: :model do
  subject { described_class.new(c100_application: c100_application) }

  let(:c100_application) { C100Application.new(payment_type: payment_type) }
  let(:payment_type) { 'foobar' }

  context 'status enumeration' do
    it 'maps all the neccessary statuses' do
      expect(PaymentIntent.statuses.keys).to eq(PaymentIntent.statuses.values)

      expect(
        PaymentIntent.statuses.keys
      ).to match_array(%w(
        ready
        created
        pending
        success
        failed
        offline_type
      ))
    end
  end

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

  describe '#finish!' do
    before do
      travel_to Time.at(0)
    end

    context 'when a status is passed' do
      it 'sets the status and the finished_at' do
        expect(subject).to receive(:update).with(status: :foobar, finished_at: Time.at(0))
        subject.finish!(with_status: :foobar)
      end
    end

    context 'when no status is passed' do
      it 'sets the status to the default, and the finished_at' do
        expect(subject).to receive(:update).with(status: :success, finished_at: Time.at(0))
        subject.finish!
      end
    end
  end

  describe '#revoke_nonce!' do
    it 'sets to nil the nonce, invalidating it' do
      expect(subject).to receive(:update_column).with(:nonce, nil)
      subject.revoke_nonce!
    end
  end
end
