require 'rails_helper'

RSpec.describe C100App::InternationalDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `resident`' do
    let(:step_params) { { resident: 'anything' } }
    it { is_expected.to have_destination(:jurisdiction, :edit) }
  end

  context 'when the step is `jurisdiction`' do
    let(:step_params) { { jurisdiction: 'anything' } }
    it { is_expected.to have_destination(:request, :edit) }
  end

  context 'when the step is `request`' do
    let(:step_params) { { request: 'anything' } }
    it { is_expected.to have_destination('/steps/application/litigation_capacity', :edit) }
  end
end
