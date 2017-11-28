require 'spec_helper'

RSpec.describe Steps::Abduction::PreviousAttemptDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    previous_attempt_details: 'details',
    previous_attempt_agency_involved: previous_attempt_agency_involved,
    previous_attempt_agency_details: nil
  } }

  let(:c100_application) { instance_double(C100Application) }
  let(:previous_attempt_agency_involved) { 'no' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:previous_attempt_details) }
      it { should validate_presence_of(:previous_attempt_agency_involved, :inclusion) }

      context 'when `previous_attempt_agency_involved` is yes' do
        let(:previous_attempt_agency_involved) { 'yes' }
        it { should validate_presence_of(:previous_attempt_agency_details) }
      end

      context 'when `previous_attempt_agency_involved` is no' do
        let(:previous_attempt_agency_involved) { 'no' }
        it { should_not validate_presence_of(:previous_attempt_agency_details) }
      end
    end

    it_behaves_like 'a has-one-association form',
                    association_name: :abduction_detail,
                    expected_attributes: {
                      previous_attempt_details: 'details',
                      previous_attempt_agency_involved: GenericYesNo::NO,
                      previous_attempt_agency_details: nil
                    }
  end
end
