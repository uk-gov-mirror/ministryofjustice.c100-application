require 'spec_helper'

RSpec.describe Steps::Children::ResidenceForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    person_ids: person_ids,
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:record) { double('Residence') }
  let(:person_ids) { %w(1 2) }

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

    context 'for valid details' do
      it 'updates the record' do
        expect(record).to receive(:update).with(
          person_ids: %w(1 2),
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
