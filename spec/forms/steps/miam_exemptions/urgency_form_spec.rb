require 'spec_helper'

RSpec.describe Steps::MiamExemptions::UrgencyForm do
  let(:arguments) { {
    c100_application: c100_application,
    group_risk: true,
    risk_applicant: false,
    risk_unreasonable_hardship: true,
    risk_children: false,
    risk_unlawful_removal_retention: true
  } }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    it_behaves_like 'a has-one-association form',
                    association_name: :exemption,
                    expected_attributes: {
                      group_risk: true,
                      risk_applicant: false,
                      risk_unreasonable_hardship: true,
                      risk_children: false,
                      risk_unlawful_removal_retention: true
                    }
  end
end
