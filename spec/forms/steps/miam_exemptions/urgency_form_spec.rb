require 'spec_helper'

RSpec.describe Steps::MiamExemptions::UrgencyForm do
  let(:arguments) { {
    c100_application: c100_application,
  } }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    it_behaves_like 'a has-one-association form',
                    association_name: :exemption,
                    expected_attributes: {
                      group_risk: false,
                      risk_applicant: false,
                      risk_unreasonable_hardship: false,
                      risk_children: false,
                      risk_unlawful_removal_retention: false,
                      group_miscarriage: false,
                      miscarriage_justice: false,
                      miscarriage_irretrievable_problems: false,
                      urgency_none: false
                    }
  end
end
