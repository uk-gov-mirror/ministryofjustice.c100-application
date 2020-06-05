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
        finished
        offline_method
      ))
    end
  end

  describe '#online_payment?' do
    it 'delegates method to the c100_application' do
      expect(c100_application).to receive(:online_payment?)
      subject.online_payment?
    end
  end

  describe '#destination_url' do
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
        subject.destination_url
      }.to change { subject.nonce }.from(nil).to(nonce)
    end

    it 'returns the destination url with the nonce parameter' do
      expect(
        subject.destination_url
      ).to eq("https://c100.justice.uk/payments/#{subject.id}/destination?nonce=#{nonce}")
    end
  end

  describe '#offline_method!' do
    before do
      travel_to Time.at(0)
      subject.save
    end

    after do
      subject.destroy
    end

    it 'changes the status' do
      expect {
        subject.offline_method!
      }.to change { subject.status }.from('ready').to('offline_method')
    end

    it 'changes the finished_at' do
      expect {
        subject.offline_method!
      }.to change { subject.finished_at }.from(nil).to(Time.at(0))
    end
  end

  describe '#revoke_nonce!' do
    it 'sets to nil the nonce, invalidating it' do
      expect(subject).to receive(:update_column).with(:nonce, nil)
      subject.revoke_nonce!
    end
  end
end
