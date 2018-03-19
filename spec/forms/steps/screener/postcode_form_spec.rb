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
      let(:children_postcodes){ nil }
      it 'is not valid' do
        expect(subject).to_not be_valid
      end

      it 'adds an error on the children_postcodes attribute' do
        subject.valid?
        expect(subject.errors[:children_postcodes]).to_not be_empty
      end
    end

    context 'when the attribute is given' do
      context 'but not a valid full postcode' do
        let(:children_postcodes){ 'SE1' }

        it 'is not valid' do
          expect(subject).to_not be_valid
        end

        it 'adds an error on the children_postcodes attribute' do
          subject.valid?
          expect(subject.errors[:children_postcodes]).to_not be_empty
        end
      end
      context 'and is a valid postcode' do
        context 'without a space, upper case' do
          let(:children_postcodes){ 'SW1H9AJ' }
          it 'is valid' do
            expect(subject).to be_valid
          end
        end
        context 'without a space, mixed case' do
          let(:children_postcodes){ 'SW1h9aj' }
          it 'is valid' do
            expect(subject).to be_valid
          end
        end
        context 'with a space, upper case' do
          let(:children_postcodes){ 'SW1H 9AJ' }
          it 'is valid' do
            expect(subject).to be_valid
          end
        end
        context 'with a space, mixed case' do
          let(:children_postcodes){ 'SW1h 9aj' }
          it 'is valid' do
            expect(subject).to be_valid
          end
        end
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
