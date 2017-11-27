require 'spec_helper'

RSpec.describe Steps::Applicant::PersonalDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    record_id: record_id,
    full_name: full_name,
    has_previous_name: has_previous_name,
    previous_full_name: previous_full_name,
    gender: gender,
    dob: dob,
    birthplace: birthplace,
    address: address,
    postcode: postcode,
    home_phone: home_phone,
    mobile_phone: mobile_phone,
    email: email
  } }

  let(:c100_application) { instance_double(C100Application, applicants: applicants_collection) }
  let(:applicants_collection) { double('applicants_collection') }
  let(:applicant) { double('Applicant') }

  let(:record_id) { nil }
  let(:full_name) { 'Full Name' }
  let(:has_previous_name) { 'no' }
  let(:previous_full_name) { nil }
  let(:gender) { 'male' }
  let(:dob) { Date.today }
  let(:birthplace) { 'London' }
  let(:address) { nil }
  let(:postcode) { nil }
  let(:home_phone) { nil }
  let(:mobile_phone) { nil }
  let(:email) { 'email@example.com' }

  subject { described_class.new(arguments) }

  describe '.gender_choices' do
    it 'returns the relevant choices' do
      expect(described_class.gender_choices).to eq(%w(female male))
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

    context 'for valid details' do
      let(:expected_attributes) {
        {
          full_name: 'Full Name',
          has_previous_name: GenericYesNo::NO,
          previous_full_name: '',
          gender: Gender::MALE,
          dob: Date.today,
          birthplace: 'London',
          address: '',
          postcode: '',
          home_phone: '',
          mobile_phone: '',
          email: 'email@example.com'
        }
      }

      context 'when record does not exist' do
        it 'creates the record if it does not exist' do
          expect(applicants_collection).to receive(:find_or_initialize_by).with(
            id: nil
          ).and_return(applicant)

          expect(applicant).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when record already exists' do
        let(:record_id) { 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6' }

        it 'updates the record if it already exists' do
          expect(applicants_collection).to receive(:find_or_initialize_by).with(
            id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6'
          ).and_return(applicant)

          expect(applicant).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
