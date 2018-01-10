require 'spec_helper'

RSpec.describe Steps::Children::ResidenceForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    person_ids: person_ids,
    other: other,
    other_full_name: other_full_name
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:record) { double('Residence') }
  let(:person_ids) { %w(1 2) }
  let(:other) { true }
  let(:other_full_name) { 'John Doe' }

  subject { described_class.new(arguments) }

  describe '#people' do
    it 'returns a flattened collection of all the people children can live with' do
      expect(c100_application).to receive(:applicants).and_return(['a'])
      expect(c100_application).to receive(:respondents).and_return(['b', 'c'])
      expect(c100_application).to receive(:other_parties).and_return(['d'])

      expect(subject.people).to eq(%w(a b c d))
    end
  end

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'validations on `other_full_name`' do
      context 'when residence is `other` and `other_full_name` is not provided' do
        let(:other) { true }
        let(:other_full_name) { nil }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the `other_full_name` field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:other_full_name]).to_not be_empty
        end
      end

      context 'when residence is `other` and `other_full_name` is provided' do
        let(:other) { true }
        let(:other_full_name) { 'John Doe' }

        it 'has no validation errors' do
          expect(subject).to be_valid
        end
      end
    end

    context 'for valid details' do
      it 'updates the record' do
        expect(record).to receive(:update).with(
          person_ids: %w(1 2),
          other: true,
          other_full_name: 'John Doe'
        ).and_return(true)

        expect(subject.save).to be(true)
      end

      context 'reset values' do
        let(:other) { false }
        let(:other_full_name) { 'John Doe' }

        it 'reset `other_full_name` when no needed' do
          expect(record).to receive(:update).with(
            person_ids: %w(1 2),
            other: false,
            other_full_name: nil
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
