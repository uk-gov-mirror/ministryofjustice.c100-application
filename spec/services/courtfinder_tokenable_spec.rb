require 'rails_helper'

RSpec.describe CourtfinderTokenable do
  subject(:tokenable) do
    Class.new do
      include CourtfinderTokenable
    end.new
  end

  before do
    CourtfinderToken.delete_all
  end

  describe '#courtfinder_api_credentials' do
    context 'when no token exists' do
      it 'returns an empty hash' do
        expect(tokenable.courtfinder_api_credentials).to eq({})
      end
    end

    context 'when the token is expired' do
      before do
        CourtfinderToken.create!(
          access_token: 'expired-token',
          expires_at: 1.hour.ago
        )
      end

      it 'returns an empty hash' do
        expect(tokenable.courtfinder_api_credentials).to eq({})
      end

      it 'does not destroy the expired token' do
        expect {
          tokenable.courtfinder_api_credentials
        }.not_to change(CourtfinderToken, :count)
      end
    end

    context 'when a valid token exists' do
      before do
        CourtfinderToken.create!(
          access_token: 'valid-token',
          expires_at: 1.hour.from_now
        )
      end

      it 'returns the access token' do
        expect(tokenable.courtfinder_api_credentials).to eq(access_token: 'valid-token')
      end
    end

    context 'when decrypting the token raises InvalidMessage' do
      before do
        CourtfinderToken.create!(
          access_token: 'valid-token',
          expires_at: 1.hour.from_now
        )

        allow_any_instance_of(CourtfinderToken).to receive(:access_token).and_raise(ActiveSupport::MessageEncryptor::InvalidMessage)
      end

      it 'destroys the invalid token and returns an empty hash' do
        expect { expect(tokenable.courtfinder_api_credentials).to eq({}) }.to change(CourtfinderToken, :count).from(1).to(0)
      end
    end
  end

  describe '#update_courtfinder_token' do
    around do |example|
      travel_to(Time.zone.local(2026, 1, 1, 12, 0, 0), &example)
    end

    context 'when no token exists' do
      it 'creates a token with the access token and expiry' do
        expect {
          tokenable.update_courtfinder_token('new-token', 3600)
        }.to change(CourtfinderToken, :count).from(0).to(1)

        token = CourtfinderToken.first

        expect(token.access_token).to eq('new-token')
        expect(token.expires_at).to eq(1.hour.from_now)
      end
    end

    context 'when a token already exists' do
      let!(:existing_token) do
        CourtfinderToken.create!(
          access_token: 'old-token',
          expires_at: 1.hour.ago
        )
      end

      it 'updates the existing token instead of creating another' do
        expect {
          tokenable.update_courtfinder_token('new-token', 7200)
        }.not_to change(CourtfinderToken, :count)

        existing_token.reload

        expect(existing_token.access_token).to eq('new-token')
        expect(existing_token.expires_at).to eq(2.hours.from_now)
      end
    end

    context 'when saving the token fails' do
      it 'raises the persistence error' do
        allow_any_instance_of(CourtfinderToken)
          .to receive(:save!)
                .and_raise(ActiveRecord::RecordInvalid)

        expect {
          tokenable.update_courtfinder_token('new-token', 3600)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end