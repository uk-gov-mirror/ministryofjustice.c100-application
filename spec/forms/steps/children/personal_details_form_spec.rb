require 'spec_helper'

RSpec.describe Steps::Children::PersonalDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    record_id: record_id,
    full_name: full_name,
    gender: gender,
    dob: dob,
    dob_unknown: dob_unknown,
    orders_applied_for: orders_applied_for,
    applicants_relationship: applicants_relationship,
    respondents_relationship: respondents_relationship
  } }

  let(:c100_application) { instance_double(C100Application, children: children_collection) }
  let(:children_collection) { double('children_collection') }
  let(:child) { double('Child') }

  let(:record_id) { nil }
  let(:full_name) { 'Full Name' }
  let(:gender) { 'male' }
  let(:dob) { Date.today }
  let(:dob_unknown) { false }
  let(:orders_applied_for) { 'orders' }
  let(:applicants_relationship) { 'relationships' }
  let(:respondents_relationship) { 'relationships' }

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
      it { should validate_presence_of(:orders_applied_for) }
      it { should validate_presence_of(:applicants_relationship) }
      it { should validate_presence_of(:respondents_relationship) }
    end

    context 'validations on field presence unless `unknown`' do
      it {should validate_presence_unless_unknown_of(:dob)}
    end

    context 'for valid details' do
      let(:expected_attributes) {
        {
          full_name: 'Full Name',
          gender: Gender::MALE,
          dob: Date.today,
          dob_unknown: false,
          orders_applied_for: 'orders',
          applicants_relationship: 'relationships',
          respondents_relationship: 'relationships'
        }
      }

      context 'when record does not exist' do
        it 'creates the record if it does not exist' do
          expect(children_collection).to receive(:find_or_initialize_by).with(
            id: nil
          ).and_return(child)

          expect(child).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when record already exists' do
        let(:record_id) { 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6' }

        it 'updates the record if it already exists' do
          expect(children_collection).to receive(:find_or_initialize_by).with(
            id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6'
          ).and_return(child)

          expect(child).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
