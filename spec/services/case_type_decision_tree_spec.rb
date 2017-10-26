require 'spec_helper'

RSpec.describe CaseTypeDecisionTree, '#destination' do
  let(:c100_application) { instance_double(C100Application, case_type: case_type) }
  let(:step_params)   { {case_type: 'anything'} }
  let(:next_step)     { nil }
  let(:case_type)     { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, next_step: next_step) }

  context 'when the case type is CHILD_ARRANGEMENTS' do
    let(:case_type) { CaseType::CHILD_ARRANGEMENTS }
    it { is_expected.to have_destination(:case_type_kickout, :show) }
  end

  context 'when the step is invalid' do
    let(:step_params) { { ungueltig: { waschmaschine: 'nein' } } }

    it 'raises an error' do
      expect { subject.destination }.to raise_error(
        BaseDecisionTree::InvalidStep, "Invalid step '{:ungueltig=>{:waschmaschine=>\"nein\"}}'"
      )
    end
  end
end
