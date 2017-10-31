require 'spec_helper'

RSpec.describe Steps::Applicant::UserTypeForm do
  let(:arguments) { {
    c100_application: c100_application,
    user_type: user_type
  } }
  let(:c100_application) { instance_double(C100Application, user_type: nil) }
  let(:user_type) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        themself
        representative
      ))
    end
  end

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application)  { nil }
      let(:user_type) { 'themself' } # This must be a correct value

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'when user_type is not given' do
      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:user_type]).to_not be_empty
      end
    end

    context 'when user_type is not valid' do
      let(:user_type) { 'INVALID VALUE' }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors[:user_type]).to_not be_empty
      end
    end

    context 'when user_type is valid' do
      let(:user_type) { 'themself' }

      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          user_type: UserType::THEMSELF
        ).and_return(true)
        expect(subject.save).to be(true)
      end
    end

    context 'when user_type is already the same on the model' do
      let(:c100_application) {
        instance_double(
          C100Application,
          user_type: UserType::THEMSELF
        )
      }
      let(:user_type) { 'themself' }

      it 'does not save the record but returns true' do
        expect(subject).to receive(:user_type_value).and_call_original
        expect(c100_application).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
