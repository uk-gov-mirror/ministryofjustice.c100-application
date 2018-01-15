require 'spec_helper'

RSpec.describe Steps::Petition::OrdersForm do
  let(:arguments) { {
    c100_application: c100_application,
    child_home: '1',
    child_times: '1',
    child_contact: '1',
    child_specific_issue_school: '0',
    child_specific_issue_religion: '0',
    child_specific_issue_name: '0',
    child_specific_issue_medical: '0',
    child_specific_issue_abroad: '0',
    child_return: '0',
    child_abduction: '0',
    child_flight: '0',
    other: other,
    other_details: other_details
  } }

  let(:c100_application) { instance_double(C100Application) }

  let(:other) { '1' }
  let(:other_details) { 'details' }

  subject { described_class.new(arguments) }

  describe '#save' do
    it_behaves_like 'a has-one-association form',
                    association_name: :asking_order,
                    expected_attributes: {
                      child_home: true,
                      child_times: true,
                      child_contact: true,
                      child_return: false,
                      child_abduction: false,
                      child_flight: false,
                      child_specific_issue_school: false,
                      child_specific_issue_religion: false,
                      child_specific_issue_name: false,
                      child_specific_issue_medical: false,
                      child_specific_issue_abroad: false,
                      other: true,
                      other_details: 'details'
                    }

    context 'validations' do
      context '`other_details` when `other` is true' do
        let(:other) { '1' }
        let(:other_details) { nil }

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors[:other_details]).to_not be_empty
        end
      end

      context '`other_details` when `other` is false' do
        let(:other) { '0' }
        let(:other_details) { nil }

        it 'has no validation errors' do
          expect(subject).to be_valid
        end
      end
    end
  end
end
