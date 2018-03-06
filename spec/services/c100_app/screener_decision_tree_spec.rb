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

    context 'and no valid courts are found' do
      before do
        allow_any_instance_of(C100App::CourtPostcodeChecker).to receive(:courts_for).with(postcodes).and_return([])
      end
      it { is_expected.to have_destination(:no_court_found, :show) }
    end

    context 'and at least one valid court is found' do
      let(:courts){
        ['i am a court',
         'i am another court']
      }
      let(:court){ instance_double('Court') }

      before do
        allow_any_instance_of(C100App::CourtPostcodeChecker).to receive(:courts_for).with(postcodes).and_return(courts)
        allow(screener_answers).to receive(:update!)
        allow_any_instance_of(Court).to receive(:from_courtfinder_data!).and_return(court)
      end

      it { is_expected.to have_destination(:urgency, :edit) }

      it 'creates a Court from the first result' do
        expect_any_instance_of(Court).to receive(:from_courtfinder_data!).with(courts.first)
        subject.destination
      end

      it 'updates the screener_answers with the Court' do
        expect(screener_answers).to receive(:update!).with(local_court: court)
        subject.destination
      end
    end

    context 'when the postcode checker raises an error' do
      before do
        allow_any_instance_of(C100App::CourtPostcodeChecker).to receive(:courts_for).and_raise("expected exception for testing, please ignore")
      end
      it { is_expected.to have_destination(:error_but_continue, :show)}
    end

    context 'when the children_postcodes are nil' do
      let(:postcodes){ nil }
      before do
        allow_any_instance_of(C100App::CourtPostcodeChecker).to receive(:courts_for).and_raise("expected exception for testing, please ignore")
      end
      it { is_expected.to have_destination(:error_but_continue, :show)}
    end
  end

  context 'when the step is `urgency`' do
    let(:as){ :urgency }
    let(:step_params){ {urgent: urgent} }
    let(:screener_answers) { double('screener_answers', urgent: urgent) }

    context 'and urgent is "yes"' do
      let(:urgent){ GenericYesNo::YES }

      it { is_expected.to have_destination(:urgent_exit, :show) }
    end

    context 'and urgent is "no"' do
      let(:urgent){ GenericYesNo::NO }

      it { is_expected.to have_destination(:parent, :edit) }
    end
  end

  context 'when the step is `parent`' do
    let(:step_params){ {parent: parent} }
    let(:screener_answers) { double('screener_answers', parent: parent) }

    context 'and parent is "yes"' do
      let(:parent){ GenericYesNo::YES }

      it { is_expected.to have_destination(:over18, :edit) }
    end

    context 'and parent is "no"' do
      let(:parent){ GenericYesNo::NO }

      it { is_expected.to have_destination(:parent_exit, :show) }
    end
  end

  context 'when the step is `over18`' do
    let(:step_params){ {over18: over18} }
    let(:screener_answers) { double('screener_answers', over18: over18) }

    context 'and over18 is "yes"' do
      let(:over18){ GenericYesNo::YES }

      it { is_expected.to have_destination(:legal_representation, :edit) }
    end

    context 'and over18 is "no"' do
      let(:over18){ GenericYesNo::NO }

      it { is_expected.to have_destination(:over18_exit, :show) }
    end
  end

  context 'when the step is `legal_representation`' do
    let(:step_params){ {legal_representation: legal_representation} }
    let(:screener_answers) { double('screener_answers', legal_representation: legal_representation) }

    context 'and legal_representation is "no"' do
      let(:legal_representation){ GenericYesNo::NO }

      it { is_expected.to have_destination(:written_agreement, :edit) }
    end

    context 'and legal_representation is "yes"' do
      let(:legal_representation){ GenericYesNo::YES }

      it { is_expected.to have_destination(:legal_representation_exit, :show) }
    end
  end

  context 'when the step is `written_agreement`' do
    let(:step_params){ {written_agreement: written_agreement} }
    let(:screener_answers) { double('screener_answers', written_agreement: written_agreement) }

    context 'and written_agreement is "no"' do
      let(:written_agreement){ GenericYesNo::NO }

      it { is_expected.to have_destination(:email_consent, :edit) }
    end

    context 'and written_agreement is "yes"' do
      let(:written_agreement){ GenericYesNo::YES }

      it { is_expected.to have_destination(:written_agreement_exit, :show) }
    end
  end

  context 'when the step is `email_consent`' do
    let(:step_params) { { email_consent: 'anything' } }
    it { is_expected.to have_destination('/steps/miam/consent_order', :edit) }
  end
end
