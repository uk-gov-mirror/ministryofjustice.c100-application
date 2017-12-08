require 'spec_helper'

RSpec.describe Steps::Respondent::ContactDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    address: address,
    postcode: postcode,
    postcode_unknown: postcode_unknown,
    home_phone: home_phone,
    mobile_phone: mobile_phone,
    mobile_phone_unknown: mobile_phone_unknown,
    email: email,
    email_unknown: email_unknown,
    residence_requirement_met: residence_requirement_met,
    residence_history: residence_history
  } }

  let(:c100_application) { instance_double(C100Application, respondents: respondents_collection) }
  let(:respondents_collection) { double('respondents_collection') }
  let(:respondent) { double('Respondent', id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6') }

  let(:record) { nil }
  let(:address) { 'address' }
  let(:postcode) { 'postcode' }
  let(:postcode_unknown) { false }
  let(:home_phone) { nil }
  let(:mobile_phone) { nil }
  let(:mobile_phone_unknown) { true }
  let(:email) { nil }
  let(:email_unknown) { true }
  let(:residence_requirement_met) { 'no' }
  let(:residence_history) { 'history' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'residence_requirement_met' do
      context 'when attribute is not given' do
        let(:residence_requirement_met) { nil }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:residence_requirement_met]).to_not be_empty
        end
      end

      context 'when attribute is given and requires residency history' do
        let(:residence_requirement_met) { 'no' }
        let(:residence_history) { nil }

        it 'has a validation error on the `residence_history` field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:residence_history]).to_not be_empty
        end
      end

      context 'when attribute is given and does not requires residency history' do
        let(:residence_requirement_met) { 'yes' }
        let(:residence_history) { nil }

        it 'has no validation errors' do
          expect(subject).to be_valid
        end
      end
    end

    context 'validations on field presence unless `unknown`' do
      it { should validate_presence_unless_unknown_of(:postcode) }
      it { should validate_presence_unless_unknown_of(:mobile_phone) }
      it { should validate_presence_unless_unknown_of(:email) }
    end

    context 'for valid details' do
      let(:expected_attributes) {
        {
          address: 'address',
          postcode: 'postcode',
          postcode_unknown: false,
          home_phone: '',
          mobile_phone: '',
          mobile_phone_unknown: true,
          email: '',
          email_unknown: true,
          residence_requirement_met: GenericYesNoUnknown::NO,
          residence_history: 'history'
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
