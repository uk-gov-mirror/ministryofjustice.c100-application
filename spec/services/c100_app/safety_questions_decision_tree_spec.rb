require 'rails_helper'

RSpec.describe C100App::SafetyQuestionsDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `risk_of_abduction`' do
    let(:c100_application) { instance_double(C100Application, risk_of_abduction: value) }
    let(:step_params) { { risk_of_abduction: 'anything' } }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination(:substance_abuse, :edit) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }
      it { is_expected.to have_destination(:substance_abuse, :edit) }
    end
  end

  context 'when the step is `substance_abuse`' do
    let(:c100_application) { instance_double(C100Application, substance_abuse: value) }
    let(:step_params) { { substance_abuse: 'anything' } }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination(:substance_abuse_details, :edit) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }
      it { is_expected.to have_destination('/steps/abuse_concerns/question', :edit) }
    end
  end

  context 'when the step is `substance_abuse_details`' do
    let(:c100_application) {instance_double(C100Application)}
    let(:step_params) { { substance_abuse_details: 'anything' } }

    it {is_expected.to have_destination('/steps/abuse_concerns/question', :edit) }
  end
end
