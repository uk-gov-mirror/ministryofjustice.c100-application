require 'rails_helper'

RSpec.describe C100App::AlternativesDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `negotiation_tools`' do
    let(:step_params) { { negotiation_tools: 'anything' } }
    it { is_expected.to have_destination(:mediation, :edit) }
  end

  context 'when the step is `mediation`' do
    let(:step_params) { { mediation: 'anything' } }
    it { is_expected.to have_destination(:lawyer_negotiation, :edit) }
  end

  context 'when the step is `lawyer_negotiation`' do
    let(:step_params) { { lawyer_negotiation: 'anything' } }
    it { is_expected.to have_destination(:collaborative_law, :edit) }
  end

  context 'when the step is `collaborative_law`' do
    let(:step_params) { { collaborative_law: 'anything' } }
    it { is_expected.to have_destination('/steps/petition/orders', :edit) }
  end
end
