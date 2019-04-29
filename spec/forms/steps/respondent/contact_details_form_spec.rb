require 'spec_helper'

RSpec.describe Steps::Respondent::ContactDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    home_phone: home_phone,
    mobile_phone: mobile_phone,
    email: email
  } }

  let(:c100_application) { instance_double(C100Application, respondents: respondents_collection) }
  let(:respondents_collection) { double('respondents_collection') }
  let(:respondent) { double('Respondent', id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6') }

  let(:record) { nil }
  let(:home_phone) { nil }
  let(:mobile_phone) { nil }
  let(:email) { 'test@test.com' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'email validation' do
      context 'email is not validated if not present' do
        let(:email) { nil }
        it { expect(subject).to be_valid }
      end

      context 'email is validated if present' do
        let(:email) { 'xxx' }
        it {
          expect(subject).not_to be_valid
          expect(subject.errors[:email]).to_not be_empty
        }
      end
    end

    context 'for valid details' do
      let(:expected_attributes) {
        {
          home_phone: '',
          mobile_phone: '',
          email: 'test@test.com'
        }
      }

      context 'when record does not exist' do
        let(:record) { nil }

        it 'creates the record if it does not exist' do
          expect(respondents_collection).to receive(:find_or_initialize_by).with(
            id: nil
          ).and_return(respondent)

          expect(respondent).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when record already exists' do
        let(:record) { respondent }

        it 'updates the record if it already exists' do
          expect(respondents_collection).to receive(:find_or_initialize_by).with(
            id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6'
          ).and_return(respondent)

          expect(respondent).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
