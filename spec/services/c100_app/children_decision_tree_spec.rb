require 'rails_helper'

RSpec.describe C100App::ChildrenDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `personal_details`' do
    let(:step_params) {{'personal_details' => 'anything'}}
    let(:c100_application) {instance_double(C100Application, number_of_children: 1)}

    it {is_expected.to have_destination(:personal_details, :edit)}
  end

  context 'when the step is `add_another_child`' do
    let(:step_params) {{'add_another_child' => 'anything'}}
    let(:c100_application) {instance_double(C100Application)}

    it {is_expected.to have_destination(:personal_details, :edit)}
  end

  context 'when the step is `children_finished`' do
    let(:step_params) {{'children_finished' => 'anything'}}
    let(:c100_application) {instance_double(C100Application)}

    it {is_expected.to have_destination(:additional_details, :edit)}
  end

  context 'when the step is `additional_details`' do
    let(:step_params) {{'additional_details' => 'anything'}}
    let(:c100_application) {instance_double(C100Application)}

    it {is_expected.to have_destination('/steps/applicant/personal_details', :edit)}
  end
end
