require 'spec_helper'

RSpec.describe Steps::Children::AdditionalDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    children_known_to_authorities: children_known_to_authorities,
    children_known_to_authorities_details: children_known_to_authorities_details,
    children_protection_plan: children_protection_plan,
    children_protection_plan_details: children_protection_plan_details,
    children_same_parents: children_same_parents,
    children_same_parents_yes_details: children_same_parents_yes_details,
    children_same_parents_no_details: children_same_parents_no_details,
    children_parental_responsibility_details: children_parental_responsibility_details,
    children_residence: children_residence,
    children_residence_details: children_residence_details
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:children_known_to_authorities) { 'unknown' }
  let(:children_known_to_authorities_details) { nil }
  let(:children_protection_plan) { 'yes' }
  let(:children_protection_plan_details) { nil }
  let(:children_same_parents) { 'yes' }
  let(:children_same_parents_yes_details) { 'details' }
  let(:children_same_parents_no_details) { nil }
  let(:children_parental_responsibility_details) { 'details' }
  let(:children_residence) { 'applicant' }
  let(:children_residence_details) { nil }

  subject { described_class.new(arguments) }

  describe '.children_residence_choices' do
    it 'returns the relevant choices' do
      expect(described_class.children_residence_choices).to eq(%w(applicant respondent other))
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :children_protection_plan, example_value: 'yes'

    let(:expected_attributes) {
      {
        children_known_to_authorities: GenericYesNoUnknown::UNKNOWN,
        children_known_to_authorities_details: nil,
        children_protection_plan: GenericYesNoUnknown::YES,
        children_protection_plan_details: nil,
        children_same_parents: GenericYesNo::YES,
        children_same_parents_yes_details: 'details',
        children_same_parents_no_details: nil,
        children_parental_responsibility_details: 'details',
        children_residence: ChildrenResidence::APPLICANT,
        children_residence_details: nil
      }
    }

    context 'validations on field presence' do
      it {should validate_presence_of(:children_parental_responsibility_details)}
      it {should validate_presence_of(:children_known_to_authorities, :inclusion)}
      it {should validate_presence_of(:children_protection_plan, :inclusion)}
      it {should validate_presence_of(:children_same_parents, :inclusion)}
      it {should validate_presence_of(:children_residence, :inclusion)}
    end

    context 'validation for `children_same_parents` option' do
      context 'when answer is `yes`' do
        let(:children_same_parents) {'yes'}
        it {should validate_presence_of(:children_same_parents_yes_details)}
        it {should_not validate_presence_of(:children_same_parents_no_details)}
      end

      context 'when answer is `no`' do
        let(:children_same_parents) {'no'}
        it {should validate_presence_of(:children_same_parents_no_details)}
        it {should_not validate_presence_of(:children_same_parents_yes_details)}
      end
    end

    context 'validation for `children_residence` option' do
      context 'when answer is `applicant`' do
        let(:children_residence) {'applicant'}
        it {should_not validate_presence_of(:children_residence_details)}
      end

      context 'when answer is `respondent`' do
        let(:children_residence) {'applicant'}
        it {should_not validate_presence_of(:children_residence_details)}
      end

      context 'when answer is `other`' do
        let(:children_residence) {'other'}
        it {should validate_presence_of(:children_residence_details)}
      end
    end

    context 'when form object is valid' do
      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          expected_attributes
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end

    context 'when the form has not changed values' do
      before do
        allow(subject).to receive(:changed?).and_return(false)
      end

      it 'does not save the record but returns true' do
        expect(c100_application).to_not receive(:update)
        expect(subject.save).to be(true)
      end
    end
  end
end
