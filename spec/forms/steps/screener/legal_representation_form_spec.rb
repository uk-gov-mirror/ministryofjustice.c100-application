require 'spec_helper'

RSpec.describe Steps::Screener::LegalRepresentationForm do
  let(:arguments) { {
    c100_application: c100_application,
    legal_representation: GenericYesNo::YES
  } }

  let(:c100_application){ instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:legal_representation, :inclusion) }
    end
    it_behaves_like 'a has-one-association form',
                    association_name: :screener_answers,
                    expected_attributes: {
                      legal_representation: GenericYesNo::YES
                    }

  end
end
