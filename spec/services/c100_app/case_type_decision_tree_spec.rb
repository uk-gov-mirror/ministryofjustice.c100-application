require 'rails_helper'

RSpec.describe C100App::CaseTypeDecisionTree, '#destination' do
  let(:c100_application) { instance_double(C100Application, case_type: case_type) }
  let(:step_params)   { {case_type: 'anything'} }
  let(:next_step)     { nil }
  let(:as)            { nil }
  let(:case_type)     { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

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

  context 'when `next_step` has been provided' do
    let(:next_step) {{controller: :another_step, action: :show}}
    it {is_expected.to have_destination(:another_step, :show)}
  end

  context 'when `next_step` has not been provided' do
    context 'when `as` has been provided will use it' do
      let(:as) { 'case_type' }
      it {is_expected.to have_destination(:case_type_kickout, :show)}
    end

    context 'when `as` has not been provided will take the step_name from the step_params' do
      before do
        expect(step_params).to receive_message_chain(:keys, :first).and_return('case_type')
      end

      it {is_expected.to have_destination(:case_type_kickout, :show)}
    end
  end
end
