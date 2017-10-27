require 'rails_helper'

RSpec.describe Steps::NatureOfApplication::CaseTypeForm do
  let(:arguments) { {
    c100_application: c100_application,
    case_type:        case_type
  } }
  let(:c100_application) { instance_double(C100Application, case_type: nil) }
  let(:case_type) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        child_arrangements
        prohibited_steps
        specific_issue
      ))
    end
  end

  describe '#save' do
    context 'when no c100 application is associated with the form' do
      let(:c100_application) { nil }
      let(:case_type)        { 'child_arrangements' }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'when case_type is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:case_type]).to_not be_empty
      end
    end

    context 'when case_type is not valid' do
      let(:case_type) { 'lave-linge-pas-cher' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:case_type]).to_not be_empty
      end
    end

    context 'when case type is valid' do
      let(:case_type) { 'child_arrangements' }

      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          case_type: CaseType::CHILD_ARRANGEMENTS
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when case_type is already the same on the model' do
      let(:c100_application) { instance_double(C100Application, case_type: CaseType::CHILD_ARRANGEMENTS) }
      let(:case_type)        { 'child_arrangements' }

      it 'does not save the record but returns true' do
        expect(subject).to receive(:case_type_value).and_call_original
        expect(c100_application).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
