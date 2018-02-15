require 'spec_helper'

RSpec.describe Steps::MiamExemptions::AdrForm do
  let(:arguments) { {
    c100_application: c100_application,
    previous_attendance: '1',
    previous_exemption: '0',
  } }

  let(:c100_application) { instance_double(C100Application, miam_exemption: miam_exemption_record) }
  let(:miam_exemption_record) { MiamExemption.new(adr: ['previous_attendance']) }

  subject { described_class.new(arguments) }

  describe 'custom getters override' do
    it 'returns true if the exemption is in the list' do
      expect(subject.previous_attendance).to eq(true)
    end

    it 'returns false if the exemption is not in the list' do
      expect(subject.previous_exemption).to eq(false)
    end
  end

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(miam_exemption_record).to receive(:update).with(
          adr: [:previous_attendance],
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
