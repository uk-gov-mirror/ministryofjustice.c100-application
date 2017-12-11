require 'spec_helper'

RSpec.describe Steps::OtherParties::ContactDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    address: address,
    postcode: postcode,
    postcode_unknown: postcode_unknown
  } }

  let(:c100_application) { instance_double(C100Application, other_parties: other_parties_collection) }
  let(:other_parties_collection) { double('other_parties_collection') }
  let(:party) { double('Party', id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6') }

  let(:record) { nil }
  let(:address) { 'address' }
  let(:postcode) { 'postcode' }
  let(:postcode_unknown) { false }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'validations on field presence unless `unknown`' do
      it { should validate_presence_unless_unknown_of(:postcode) }
    end

    context 'for valid details' do
      let(:expected_attributes) {
        {
          address: 'address',
          postcode: 'postcode',
          postcode_unknown: false
        }
      }

      context 'when record does not exist' do
        let(:record) { nil }

        it 'creates the record if it does not exist' do
          expect(other_parties_collection).to receive(:find_or_initialize_by).with(
            id: nil
          ).and_return(party)

          expect(party).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'when record already exists' do
        let(:record) { party }

        it 'updates the record if it already exists' do
          expect(other_parties_collection).to receive(:find_or_initialize_by).with(
            id: 'ae4ed69e-bcb3-49cc-b19e-7287b1f2abe6'
          ).and_return(party)

          expect(party).to receive(:update).with(
            expected_attributes
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
