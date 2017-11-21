require 'spec_helper'

RSpec.describe Steps::SafetyQuestions::SubstanceAbuseDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    substance_abuse_details: substance_abuse_details
  } }
  let(:c100_application) { instance_double(C100Application, substance_abuse_details: nil) }
  let(:substance_abuse_details) { nil }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it {should validate_presence_of(:substance_abuse_details)}
    end

    context 'when form is valid' do
      let(:substance_abuse_details) { 'details' }

      it 'saves the record' do
        expect(c100_application).to receive(:update).with(
          substance_abuse_details: substance_abuse_details
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
