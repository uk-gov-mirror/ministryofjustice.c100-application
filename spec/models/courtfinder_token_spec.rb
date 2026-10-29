require 'rails_helper'

RSpec.describe CourtfinderToken do
  subject(:token) { described_class.new(access_token: '123456', expires_at: expires_at) }
  let(:expires_at) { Time.zone.parse('01-02-2021 10:55') }

  context 'expired?' do
    it 'yes' do
      travel_to(Time.zone.parse('01-02-2021 11:55')) do
        expect(token.expired?).to be_truthy
      end
    end

    it 'yes if nil' do
      token.expires_at = nil
      expect(token.expired?).to be_truthy
    end

    it 'no' do
      travel_to(Time.zone.parse('01-02-2021 9:55')) do
        expect(token.expired?).to be_falsey
      end
    end
  end
end
