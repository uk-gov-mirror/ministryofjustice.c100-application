require 'rails_helper'

RSpec.describe C100App::HelpWithFeesDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `help_paying`' do
    let(:step_params) {{help_paying: 'anything'}}

    context 'and the answer is `YES`' do
      let(:c100_application) {instance_double(C100Application, help_paying: HelpPaying::YES)}
      it {is_expected.to have_destination('/entrypoint', :v1)}
    end

    context 'and the answer is `NO`' do
      let(:c100_application) {instance_double(C100Application, help_paying: HelpPaying::NO)}
      it {is_expected.to have_destination('/entrypoint', :v1)}
    end
  end
end
