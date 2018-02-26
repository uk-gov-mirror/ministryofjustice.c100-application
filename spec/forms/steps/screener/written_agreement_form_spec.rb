require 'spec_helper'

RSpec.describe Steps::Screener::WrittenAgreementForm do
  let(:arguments) { {
    c100_application: c100_application,
    written_agreement: GenericYesNo::YES
  } }

  let(:c100_application){ instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:written_agreement, :inclusion) }
    end
    it_behaves_like 'a has-one-association form',
                    association_name: :screener_answers,
                    expected_attributes: {
                      written_agreement: GenericYesNo::YES
                    }

  end
end
