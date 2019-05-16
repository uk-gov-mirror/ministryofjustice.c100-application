require 'spec_helper'

RSpec.describe Steps::Respondent::AddressDetailsForm do

  it_behaves_like 'a address CRUD form', Respondent

  let(:arguments) do
    {
      c100_application: c100_application,
      record: record,
      address: address,
      address_line_1: address_line_1,
      address_line_2: address_line_2,
      town: town,
      country: country,
      postcode: postcode,
      address_unknown: address_unknown,
      residence_requirement_met: residence_requirement_met,
      residence_history: residence_history
    }
  end
  let(:c100_application) { instance_double(C100Application, respondents: respondents_collection) }
  let(:respondents_collection) { double('respondents_collection') }
  let(:respondent) { double('Respondent', id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe9') }

  let(:record) { nil }
  let(:address) { 'address' }
  let(:address_unknown) { false }
  let(:residence_requirement_met) { 'no' }
  let(:residence_history) { 'history' }

  let(:address_line_1) { nil }
  let(:address_line_2) { nil }
  let(:town) { nil }
  let(:country) { nil }
  let(:postcode) { nil }
  let(:split_address_result) { false }

  before do
    allow(subject).to receive(:split_address?).and_return(split_address_result)
  end

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
      it { should validate_presence_unless_unknown_of(:address) }
    end

    context 'for valid details' do
      let(:expected_attributes) {
        {
          address: 'address',
          address_unknown: false,
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
            id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe9'
          ).and_return(respondent)

          expect(respondent).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end

    context 'when split address' do
      let(:split_address_result) { true }

      let(:address_data) do
        {
          address_line_1: address_line_1,
          address_line_2: address_line_2,
          town: town,
          country: country,
          postcode: postcode
        }
      end

      # TODO: after the feature flag split_address has been removed this validation
      # need to be changed to it { should validate_presence_unless_unknown_of(:address_line_1) }
      context 'validations on field presence based on validate_split_address? value' do
        context 'should validations on field presence when validate_split_address? is true ' do
          it { should validate_presence_of(:address_line_1) }
          it { should validate_presence_of(:town) }
        end

        context 'should not validations on field presence when validate_split_address? is false' do
          let(:address_unknown) { true }
          it { should_not validate_presence_of(:address_line_1) }
          it { should_not validate_presence_of(:town) }
        end
      end

      context 'address_line_1' do
        context 'when attribute is not given' do
          let(:address_line_1) { nil }

          it 'returns false' do
            expect(subject.save).to be(false)
          end

          it 'has a validation error on the field' do
            expect(subject).to_not be_valid
            expect(subject.errors[:address_line_1]).to_not be_empty
          end
        end
      end

      context 'for valid details' do
        let(:expected_attributes) {
          {
            address_data: address_data,
            address_unknown: false,
            residence_requirement_met: GenericYesNoUnknown::NO,
            residence_history: 'history'
          }
        }

        context 'when record does not exist' do
          let(:record) { nil }
          let(:address_line_1) { 'address_line_1' }
          let(:address_line_2) { 'address_line_2' }
          let(:town) { 'town' }
          let(:country) { 'c' }
          let(:postcode) { 'postcode' }

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
          let(:address_line_1) { 'address_line_1' }
          let(:address_line_2) { 'address_line_2' }
          let(:town) { 'town' }
          let(:country) { 'c' }
          let(:postcode) { 'postcode' }

          it 'updates the record if it already exists' do
            expect(respondents_collection).to receive(:find_or_initialize_by).with(
              id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe9'
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
end
