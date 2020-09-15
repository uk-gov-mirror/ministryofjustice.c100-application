require 'rails_helper'

RSpec.describe C100App::ScreenerDecisionTree do
  let(:postcodes)        { 'anything' }
  let(:local_court)      { {} }
  let(:screener_answers) { double('screener_answers', children_postcodes: postcodes, local_court: local_court) }
  let(:c100_application) { double('Object', screener_answers: screener_answers) }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `children_postcodes`' do
    let(:step_params) { { children_postcodes: postcodes } }

    context 'and no valid court is found' do
      before do
        allow_any_instance_of(C100App::CourtPostcodeChecker).to receive(:court_for).with(postcodes).and_return(nil)
      end
      it { is_expected.to have_destination(:no_court_found, :show) }
    end

    context 'and one valid court is found' do
      let(:found_court) { double('raw court data') }
      let(:court) { instance_double('Court') }

      before do
        allow_any_instance_of(C100App::CourtPostcodeChecker).to receive(:court_for).with(postcodes).and_return(found_court)
        allow(screener_answers).to receive(:update!)
        allow(Court).to receive(:build).and_return(court)
      end

      it { is_expected.to have_destination(:done, :show) }

      it 'creates a Court from the result' do
        expect(Court).to receive(:build).with(found_court)
        subject.destination
      end

      it 'updates the screener_answers with the Court' do
        expect(screener_answers).to receive(:update!).with(local_court: court)
        subject.destination
      end
    end

    context 'when the postcode checker raises an error' do
      before do
        allow_any_instance_of(C100App::CourtPostcodeChecker).to receive(:court_for).and_raise("expected exception for testing, please ignore")
      end
      it { is_expected.to have_destination(:error_but_continue, :show)}
    end

    context 'when the children_postcodes are nil' do
      let(:postcodes){ nil }
      before do
        allow_any_instance_of(C100App::CourtPostcodeChecker).to receive(:court_for).and_raise("expected exception for testing, please ignore")
      end
      it { is_expected.to have_destination(:error_but_continue, :show)}
    end
  end
end
