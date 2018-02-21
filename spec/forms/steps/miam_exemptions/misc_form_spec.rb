require 'spec_helper'

RSpec.describe Steps::MiamExemptions::MiscForm do
  let(:arguments) { {
    c100_application: c100_application,
    no_respondent_address: '1',
    access_prohibited: '0',
  } }

  let(:c100_application) { instance_double(C100Application, miam_exemption: miam_exemption_record) }
  let(:miam_exemption_record) { MiamExemption.new(misc: ['no_respondent_address']) }

  subject { described_class.new(arguments) }

  describe 'custom getters override' do
    it 'returns true if the exemption is in the list' do
      expect(subject.no_respondent_address).to eq(true)
    end

    it 'returns false if the exemption is not in the list' do
      expect(subject.access_prohibited).to eq(false)
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
          misc: [:no_respondent_address],
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end