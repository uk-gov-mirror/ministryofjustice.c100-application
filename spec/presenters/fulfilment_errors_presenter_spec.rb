require 'spec_helper'

RSpec.describe FulfilmentErrorsPresenter do
  subject { described_class.new(c100_application) }

  let(:c100_application) { C100Application.new }

  describe '#errors' do
    context 'there are no errors' do
      it 'returns an empty collection' do
        expect(subject.errors).to be_empty
      end
    end

    context 'there are errors' do
      before do
        # Add a fake error as an example (the attribute must exist)
        c100_application.errors.add(:miam_acknowledgement, :blank, change_path: 'steps/foo/bar')
      end

      it 'returns a collection of `FulfilmentError` instances' do
        expect(subject.errors).to match_instances_array([FulfilmentError])
      end

      it 'the `FulfilmentError` contains all the information needed' do
        error = subject.errors.first

        expect(error.attribute).to eq(:miam_acknowledgement)
        expect(error.message).to eq('Enter an answer')
        expect(error.error).to eq(:blank)
        expect(error.change_path).to eq('steps/foo/bar')
      end
    end
  end
end
