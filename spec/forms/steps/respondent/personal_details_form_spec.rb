require 'spec_helper'

RSpec.describe Steps::Respondent::PersonalDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    record_id: record_id,
    full_name: full_name,
    has_previous_name: has_previous_name,
    previous_full_name: previous_full_name,
    gender: gender,
    dob: dob,
    dob_unknown: dob_unknown,
    birthplace: birthplace,
    address: address,
    postcode: postcode,
    postcode_unknown: postcode_unknown,
    home_phone: home_phone,
    mobile_phone: mobile_phone,
    mobile_phone_unknown: mobile_phone_unknown,
    email: email,
    email_unknown: email_unknown
  } }

  let(:c100_application) { instance_double(C100Application, respondents: respondents_collection) }
  let(:respondents_collection) { double('respondents_collection') }
  let(:respondent) { double('Respondent') }

  let(:record_id) { nil }
  let(:full_name) { 'Full Name' }
  let(:has_previous_name) { 'no' }
  let(:previous_full_name) { nil }
  let(:gender) { 'male' }
  let(:dob) { Date.today }
  let(:dob_unknown) { false }
  let(:birthplace) { 'London' }
  let(:address) { 'Address' }
  let(:postcode) { nil }
  let(:postcode_unknown) { true }
  let(:home_phone) { '123456789' }
  let(:mobile_phone) { nil }
  let(:mobile_phone_unknown) { false }
  let(:email) { 'email@example.com' }
  let(:email_unknown) { false }

  subject { described_class.new(arguments) }

  describe '.gender_choices' do
    it 'returns the relevant choices' do
      expect(described_class.gender_choices).to eq(%w(female male))
    end
  end

  describe '.has_previous_name_choices' do
    it 'returns the relevant choices' do
      expect(described_class.has_previous_name_choices).to eq(%w(yes no unknown))
    end
  end

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'has previous name' do
      context 'when attribute is not given' do
        let(:has_previous_name) { nil }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:has_previous_name]).to_not be_empty
        end
      end

      context 'when attribute is given and requires previous name' do
        let(:has_previous_name) { 'yes' }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the `previous_full_name` field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:previous_full_name]).to_not be_empty
        end
      end

      context 'when attribute value is not valid' do
        let(:has_previous_name) {'INVALID VALUE'}

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:has_previous_name]).to_not be_empty
        end
      end
    end

    context 'gender' do
      context 'when attribute is not given' do
        let(:gender) { nil }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:gender]).to_not be_empty
        end
      end

      context 'when attribute value is not valid' do
        let(:gender) {'INVALID VALUE'}

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:gender]).to_not be_empty
        end
      end
    end

    context 'validations on field presence' do
      it { should validate_presence_of(:full_name) }
      it { should validate_presence_of(:address) }
      it { should validate_presence_of(:home_phone) }
    end

    context 'validations on field presence unless `unknown`' do
      it {should validate_presence_unless_unknown_of(:dob)}
      it {should validate_presence_unless_unknown_of(:postcode)}
      it {should validate_presence_unless_unknown_of(:email)}
    end

    context 'for valid details' do
      let(:expected_attributes) {
        {
          full_name: 'Full Name',
          has_previous_name: GenericYesNoUnknown::NO,
          previous_full_name: '',
          gender: Gender::MALE,
          dob: Date.today,
          dob_unknown: false,
          birthplace: 'London',
          address: 'Address',
          postcode: '',
          postcode_unknown: true,
          home_phone: '123456789',
          mobile_phone: '',
          mobile_phone_unknown: false,
          email: 'email@example.com',
          email_unknown: false
        }
      }

      context 'when record does not exist' do
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
        let(:record_id) { 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6' }

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
