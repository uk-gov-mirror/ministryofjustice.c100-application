require 'spec_helper'

RSpec.describe Steps::Address::LookupForm do
  let(:arguments) { {
    c100_application: c100_application,
    record: record,
    postcode: postcode,
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:record) { nil }
  let(:postcode) { 'SW1H 9AJ' }

  subject { described_class.new(arguments) }

  describe '#to_partial_path' do
    let(:path) { subject.to_partial_path }

    context 'for an `Applicant` record' do
      let(:record) { Applicant.new }
      it { expect(path).to eq('steps/address/lookup/applicant') }
    end

    context 'for a `Respondent` record' do
      let(:record) { Respondent.new }
      it { expect(path).to eq('steps/address/lookup/respondent') }
    end

    context 'for an `OtherParty` record' do
      let(:record) { OtherParty.new }
      it { expect(path).to eq('steps/address/lookup/other_party') }
    end
  end

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'when the attribute is not given' do
      let(:postcode) { nil }

      it 'adds a `blank` error on the attribute' do
        expect(subject).not_to be_valid
        expect(subject.errors.added?(:postcode, :blank)).to eq(true)
      end
    end

    context 'when the attribute is given but is not a valid postcode' do
      let(:postcode) { 'SE1' }

      it 'adds an `invalid` error on the attribute' do
        expect(subject).not_to be_valid
        expect(subject.errors.added?(:postcode, :invalid)).to eq(true)
      end
    end

    context 'for valid details' do
      let(:record) { spy(Applicant) }

      it 'updates the record' do
        expect(record).to receive(:update).with(
          postcode: 'SW1H 9AJ'
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
