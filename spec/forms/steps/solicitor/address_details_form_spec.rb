require 'spec_helper'

RSpec.describe Steps::Solicitor::AddressDetailsForm do
  let(:arguments) { {
    c100_application: c100_application,
    address: 'address',
  } }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:address) }
    end

    it_behaves_like 'a has-one-association form',
                    association_name: :solicitor,
                    expected_attributes: {
                      address: 'address',
                    }
  end
end
