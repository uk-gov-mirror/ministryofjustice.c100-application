require 'spec_helper'

RSpec.describe Steps::MiamExemptions::SafetyForm do
  let(:arguments) { {
    c100_application: c100_application,
    group_police: true,
    police_arrested: false,
    police_caution: true,
    police_ongoing_proceedings: false,
    police_conviction: true,
    police_dvpn: false
  } }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    it_behaves_like 'a has-one-association form',
                    association_name: :exemption,
                    expected_attributes: {
                      group_police: true,
                      police_arrested: false,
                      police_caution: true,
                      police_ongoing_proceedings: false,
                      police_conviction: true,
                      police_dvpn: false
                    }
  end
end
