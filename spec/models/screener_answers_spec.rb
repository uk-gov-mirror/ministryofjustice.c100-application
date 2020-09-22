require 'rails_helper'

RSpec.describe ScreenerAnswers, type: :model do
  subject { described_class.new(local_court: local_court) }

  let(:local_court) { nil }

  describe '#court' do
    context 'when there is a local_court' do
      let(:local_court) { { "name" => 'whatever' } }

      it 'returns a Court' do
        expect(Court).to receive(:build).with(local_court)
        subject.court
      end
    end

    context 'when there is no local_court' do
      it 'returns nil' do
        expect(subject.court).to eq(nil)
      end
    end
  end
end
