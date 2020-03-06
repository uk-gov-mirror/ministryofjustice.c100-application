require 'spec_helper'

RSpec.describe FulfilmentError do
  subject {
    described_class.new(:foobar, message: 'Foobar message', error: :blank, change_path: 'steps/foo/bar')
  }

  describe '#to_partial_path' do
    it 'returns the correct partial path' do
      expect(subject.to_partial_path).to eq('steps/application/check_your_answers/fulfilment_error')
    end
  end

  context 'expose the error details as attributes' do
    describe '#attribute' do
      it { is_expected.to have_attributes(attribute: :foobar) }
    end

    describe '#message' do
      it { is_expected.to have_attributes(message: 'Foobar message') }
    end

    describe '#error' do
      it { is_expected.to have_attributes(error: :blank) }
    end

    describe '#change_path' do
      it { is_expected.to have_attributes(change_path: 'steps/foo/bar') }
    end
  end
end
