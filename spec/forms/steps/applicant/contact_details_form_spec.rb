require 'spec_helper'

RSpec.describe Steps::Applicant::ContactDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    home_phone: home_phone,
    mobile_phone: mobile_phone,
    email: email,
  } }

  let(:c100_application) { instance_double(C100Application, applicants: applicants_collection) }
  let(:applicants_collection) { double('applicants_collection') }
  let(:applicant) { double('Applicant', id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6') }

  let(:record) { nil }
  let(:home_phone) { nil }
  let(:mobile_phone) { '12345' }
  let(:email) { 'test@example.com' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'mobile phone validation' do
      let(:mobile_phone) { nil }

      it 'has a validation error on the field if not present' do
        expect(subject).to_not be_valid
        expect(subject.errors.added?(:mobile_phone, :blank)).to eq(true)
      end
    end

    context 'email validation' do
      let(:email) { nil }

      it 'has a validation error on the field if not present' do
        expect(subject).to_not be_valid
        expect(subject.errors.added?(:email, :blank)).to eq(true)
      end
    end

    context 'for valid details' do
      let(:expected_attributes) {
        {
          home_phone: '',
          mobile_phone: '12345',
          email: 'test@example.com'
        }
      }

      context 'when record does not exist' do
        let(:record) { nil }

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
        let(:record) { applicant }

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
