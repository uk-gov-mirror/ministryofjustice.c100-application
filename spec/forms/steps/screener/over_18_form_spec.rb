require 'spec_helper'

RSpec.describe Steps::Screener::Over18Form do
  let(:arguments) { {
    c100_application: c100_application,
    over18: GenericYesNo::YES
  } }

  let(:c100_application){ instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:over18, :inclusion) }
    end
    it_behaves_like 'a has-one-association form',
                    association_name: :screener_answers,
                    expected_attributes: {
                      over18: GenericYesNo::YES
                    }

  end
end
