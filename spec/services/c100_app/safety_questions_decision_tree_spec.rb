require 'rails_helper'

RSpec.describe C100App::SafetyQuestionsDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `user_type`' do
    let(:step_params) { { risk_of_abduction: 'anything' } }

    # TODO: change test when we do something with the answer yes/no
    context 'and the answer is `yes`' do
      let(:c100_application) { instance_double(C100Application, risk_of_abduction: GenericYesNo::YES) }
      it { is_expected.to have_destination('/steps/abuse_concerns/question', :edit) }
    end

    # TODO: change test when we do something with the answer yes/no
    context 'and the answer is `no`' do
      let(:c100_application) { instance_double(C100Application, risk_of_abduction: GenericYesNo::NO) }
      it { is_expected.to have_destination('/steps/abuse_concerns/question', :edit) }
    end
  end
end
