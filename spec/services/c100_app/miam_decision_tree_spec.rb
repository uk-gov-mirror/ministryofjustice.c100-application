require 'rails_helper'

RSpec.describe C100App::MiamDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `miam_acknowledgement`' do
    let(:step_params) { { miam_acknowledgement: 'anything' } }
    it { is_expected.to have_destination('/steps/applicant/number_of_children', :edit) }
  end
end
