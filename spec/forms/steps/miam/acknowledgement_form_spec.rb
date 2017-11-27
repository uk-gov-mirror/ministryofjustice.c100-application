require 'spec_helper'

RSpec.describe Steps::Miam::AcknowledgementForm do
  let(:arguments) { {
    c100_application: c100_application,
    miam_acknowledgement: miam_acknowledgement
  } }
  let(:c100_application) { instance_double(C100Application, miam_acknowledgement: nil) }
  let(:miam_acknowledgement) { '1' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'validations' do
      it { should validate_presence_of(:miam_acknowledgement) }
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          miam_acknowledgement: true
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
