require 'rails_helper'

RSpec.describe ScreenerAnswers, type: :model do
  subject { described_class.new(local_court: local_court) }

  describe '#court' do
    let(:court) { instance_double(Court) }

    context 'when there is a local_court' do
      let(:local_court) {Court.new(name: 'my court')}
      let(:new_court) {Court.new(name: 'my court')}

      before do
        allow_any_instance_of(Court).to receive(:from_courtfinder_data!).and_return(court)
      end

      it 'returns a Court' do
        expect(subject.court).to eq(court)
      end
    end

    context 'when there is no local_court' do
      let(:local_court) {nil}

      it 'returns nil' do
        expect(subject.court).to eq(nil)
      end
    end
  end
end
