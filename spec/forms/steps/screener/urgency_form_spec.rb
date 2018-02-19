require 'spec_helper'

RSpec.describe Steps::Screener::UrgencyForm do
  let(:arguments) { {
    c100_application: c100_application,
    urgent: GenericYesNo::YES
  } }

  let(:c100_application){ instance_double(C100Application) }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'validations' do
      it { should validate_presence_of(:urgent, :inclusion) }
    end
    it_behaves_like 'a has-one-association form',
                    association_name: :screener_answers,
                    expected_attributes: {
                      urgent: GenericYesNo::YES
                    }

  end

  describe '#local_court' do
    let(:screener_answers){ instance_double('screener_answers', local_court: 'my local court') }
    let(:c100_application){ instance_double(C100Application, screener_answers: screener_answers) }

    it 'returns the screener_answers.local_court' do
      expect(subject.local_court).to eq('my local court')
    end
  end
end
