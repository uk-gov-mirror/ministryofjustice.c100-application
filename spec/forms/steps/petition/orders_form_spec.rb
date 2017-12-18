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
    other: '0',
  } }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    it_behaves_like 'a has-one-association form',
                    association_name: :asking_order,
                    expected_attributes: {
                      child_home: true,
                      child_times: true,
                      child_contact: true,
                      child_specific_issue_school: false,
                      child_specific_issue_religion: false,
                      child_specific_issue_name: false,
                      child_specific_issue_medical: false,
                      child_specific_issue_abroad: false,
                      child_return: false,
                      child_abduction: false,
                      child_flight: false,
                      other: false
                    }
  end
end
