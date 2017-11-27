require 'spec_helper'

RSpec.describe Steps::Abduction::ChildrenHavePassportForm do
  let(:arguments) { {
    c100_application: c100_application,
    children_have_passport: 'yes'
  } }

  let(:c100_application) { instance_double(C100Application, abduction_detail: abduction_detail) }
  let(:abduction_detail) { double('abduction_detail') }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'validations' do
      it { should validate_presence_of(:children_have_passport, :inclusion) }
    end

    context 'for valid details' do
      let(:expected_attributes) {
        {
          children_have_passport: GenericYesNo::YES
        }
      }

      context 'when record does not exist' do
        before do
          allow(c100_application).to receive(:abduction_detail).and_return(nil)
        end

        it 'creates the record if it does not exist' do
          expect(c100_application).to receive(:build_abduction_detail).and_return(abduction_detail)

          expect(abduction_detail).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when record already exists' do
        before do
          allow(c100_application).to receive(:abduction_detail).and_return(abduction_detail)
        end

        it 'updates the record if it already exists' do
          expect(c100_application).not_to receive(:build_abduction_detail)

          expect(abduction_detail).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
