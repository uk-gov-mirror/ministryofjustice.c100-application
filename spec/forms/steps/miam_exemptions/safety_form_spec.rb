require 'spec_helper'

RSpec.describe Steps::MiamExemptions::SafetyForm do
  let(:arguments) { {
    c100_application: c100_application,
  } }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    it_behaves_like 'a has-one-association form',
                    association_name: :exemption,
                    expected_attributes: {
                      group_police: false,
                      police_arrested: false,
                      police_caution: false,
                      police_ongoing_proceedings: false,
                      police_conviction: false,
                      police_dvpn: false,

                      group_court: false,
                      court_bound_over: false,
                      court_protective_injunction: false,
                      court_undertaking: false,
                      court_finding_of_fact: false,
                      court_expert_report: false,

                      group_specialist: false,
                      specialist_examination: false,
                      specialist_referral: false,

                      group_local_authority: false,
                      local_authority_marac: false,
                      local_authority_la_ha: false,
                      local_authority_public_authority: false,

                      group_da_service: false,
                      da_service_idva: false,
                      da_service_isva: false,
                      da_service_organisation: false,
                      da_service_refuge_refusal: false,

                      right_to_remain: false,
                      financial_abuse: false,
                      safety_none: false
                    }
  end
end
