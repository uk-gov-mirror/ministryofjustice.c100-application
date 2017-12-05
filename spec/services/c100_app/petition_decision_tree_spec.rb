require 'rails_helper'

RSpec.describe C100App::PetitionDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `orders`' do
    let(:c100_application) { instance_double(C100Application) }
    let(:step_params) { { orders: 'anything', other: value } }

    context 'and the checkbox `other` is selected' do
      let(:value) { '1' }
      it { is_expected.to have_destination(:other_issue, :edit) }
    end

    context 'and the checkbox `other` is not selected' do
      let(:value) { '0' }
      it { is_expected.to have_destination('/steps/children/names', :edit) }
    end
  end

  context 'when the step is `other_issue`' do
    let(:step_params) { { other_issue: 'anything' } }
    it { is_expected.to have_destination('/steps/children/names', :edit) }
  end
end
