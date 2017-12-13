require 'spec_helper'

RSpec.describe Steps::Petition::OtherIssueForm do
  let(:arguments) { {
    c100_application: c100_application,
    other_details: 'details',
    child_arrangements_order: '1',
    prohibited_steps_order: '0',
    specific_issue_order: '1'
  } }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:other_details) }
    end

    it_behaves_like 'a has-one-association form',
                    association_name: :asking_order,
                    expected_attributes: {
                      other_details: 'details',
                      child_arrangements_order: true,
                      prohibited_steps_order: false,
                      specific_issue_order: true
                    }
  end
end
