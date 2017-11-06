require 'rails_helper'

RSpec.describe C100App::RespondentDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `number_of_children`' do
    let(:step_params) {{'number_of_children' => 'anything'}}
    let(:c100_application) {instance_double(C100Application, number_of_children: 1)}

    it {is_expected.to have_destination(:personal_details, :edit)}
  end

  context 'when the step is `add_another_respondent`' do
    let(:step_params) {{'add_another_respondent' => 'anything'}}
    let(:c100_application) {instance_double(C100Application)}

    it {is_expected.to have_destination(:personal_details, :edit)}
  end

  # TODO: this is a placeholder, to be updated when we actually have the next (real) step
  context 'when the step is `respondents_finished`' do
    let(:step_params) {{'respondents_finished' => 'anything'}}
    let(:c100_application) {instance_double(C100Application)}

    it {is_expected.to have_destination('/entrypoint', :v1)}
  end
end
