require 'spec_helper'

RSpec.describe Steps::Screener::PostcodeForm do

  let(:arguments) { {
    c100_application: c100_application,
    children_postcodes: children_postcodes
  } }

  let(:screener_answers){ instance_double(ScreenerAnswers, children_postcodes: '') }

  let(:c100_application) { 
    instance_double(C100Application, screener_answers: screener_answers)
  }
  let(:children_postcodes)  { 'E3 6AA' }

  subject { described_class.new(arguments) }

  describe '#save' do
    it_behaves_like 'a has-one-association form',
                    association_name: :screener_answers,
                    expected_attributes: {
                      children_postcodes: "E3 6AA"
                    }

    context 'when the attribute is not given' do
      it 'does not have a validation error' do
        expect(subject).to be_valid
      end
      it 'saves ok' do
        allow(screener_answers).to receive(:update).and_return(true)
        expect(subject.save).to eq(true)
      end
    end
    context 'when form is valid' do
      it 'saves the record' do
        expect(screener_answers).to receive(:update).with(
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
