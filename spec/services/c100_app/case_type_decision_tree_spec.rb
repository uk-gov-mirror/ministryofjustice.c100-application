require 'rails_helper'

RSpec.describe C100App::CaseTypeDecisionTree, '#destination' do
  let(:c100_application) { instance_double(C100Application, case_type: case_type) }
  let(:step_params)   { {case_type: 'anything'} }
  let(:next_step)     { nil }
  let(:as)            { nil }
  let(:case_type)     { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the case type is CHILD_ARRANGEMENTS' do
    let(:case_type) { CaseType::CHILD_ARRANGEMENTS }
    it { is_expected.to have_destination(:case_type_kickout, :show) }
  end
end
