require 'spec_helper'

RSpec.describe Steps::PostcodeScreen::ChildrenPostcodesForm do

  let(:arguments) { {
    c100_application: c100_application,
    children_postcodes: children_postcodes
  } }

  let(:c100_application) { instance_double(C100Application, children_postcodes: '') }
  let(:children_postcodes)  { 'E3 6AA' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when the attribute is not given' do
      it 'does not have a validation error' do
        expect(subject).to be_valid
      end
      it 'saves ok' do
        allow(c100_application).to receive(:update).and_return(true)
        expect(subject.save).to eq(true)
      end
    end
    context 'when form is valid' do
      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          children_postcodes: children_postcodes
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end

    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

  end
end
