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

      it 'returns a collection of errors' do
        expect(subject.errors).to be_an_instance_of(Array)
      end

      context 'returned error' do
        let(:error) { subject.errors.first }

        it 'contains all the information needed' do
          expect(error.attribute).to eq(:miam_acknowledgement)
          expect(error.message).to eq('Enter an answer')
          expect(error.error).to eq(:blank)
          expect(error.change_path).to eq('steps/foo/bar')
        end
      end
    end
  end
end
