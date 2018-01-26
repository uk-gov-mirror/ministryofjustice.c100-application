require 'rails_helper'

RSpec.describe C100App::PostcodeScreenDecisionTree do
  let(:c100_application) { double('Object', children_postcodes: 'anything') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'


  context 'when the step is `children_postcodes`' do
    let(:step_params) { { children_postcodes: 'ldksgjdl' } }
  
    context 'and no valid courts are found' do
      before do
        allow_any_instance_of(C100App::CourtPostcodeChecker).to receive(:courts_for).and_return([])
      end
      it { is_expected.to have_destination(:no_court_found, :show) }
    end
  
    context 'and at least one valid court is found' do
      before do
        allow_any_instance_of(C100App::CourtPostcodeChecker).to receive(:courts_for).and_return(['i am a court'])
      end
      it { is_expected.to have_destination('/steps/miam/consent_order', :edit) }
    end

    context 'when the postcode checker raises an error' do
      before do
        allow_any_instance_of(C100App::CourtPostcodeChecker).to receive(:courts_for).and_raise("expected exception for testing, please ignore")
      end
      it { is_expected.to have_destination(:error_but_continue, :show)}
    end
  end
end
