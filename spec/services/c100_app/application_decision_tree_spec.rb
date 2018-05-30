require 'rails_helper'

RSpec.describe C100App::ApplicationDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  describe 'when the step is `previous_proceedings`' do
    let(:c100_application) { instance_double(C100Application, children_previous_proceedings: answer) }
    let(:step_params) { { previous_proceedings: 'whatever' } }

    context 'when answer is `yes`' do
      let(:answer) { 'yes' }
      it { is_expected.to have_destination(:court_proceedings, :edit) }
    end

    context 'when answer is `no`' do
      let(:answer) { 'no' }
      it { is_expected.to have_destination(:without_notice, :edit) }
    end
  end

  context 'when the step is `court_proceedings`' do
    let(:step_params) { { court_proceedings: 'anything' } }
    it { is_expected.to have_destination(:without_notice, :edit) }
  end

  context 'when the step is `without_notice`' do
    let(:c100_application) { instance_double(C100Application, without_notice: answer) }
    let(:step_params) { { without_notice: 'whatever' } }

    context 'and the answer is `yes`' do
      let(:answer) { 'yes' }
      it { is_expected.to have_destination(:without_notice_details, :edit) }
    end

    context 'and the answer is `no`' do
      let(:answer) { 'no' }
      it { is_expected.to have_destination('/steps/international/resident', :edit) }
    end
  end

  context 'when the step is `without_notice_details`' do
    let(:step_params) { { without_notice_details: 'anything' } }
    it { is_expected.to have_destination('/steps/international/resident', :edit) }
  end

  context 'when the step is `application_details`' do
    let(:step_params) { { application_details: 'anything' } }
    it { is_expected.to have_destination(:language, :edit) }
  end

  context 'when the step is `language`' do
    let(:step_params) { { language: 'anything' } }
    it { is_expected.to have_destination(:litigation_capacity, :edit) }
  end

  context 'when the step is `litigation_capacity`' do
    let(:c100_application) { instance_double(C100Application, reduced_litigation_capacity: answer) }
    let(:step_params) { { litigation_capacity: 'whatever' } }

    context 'and the answer is `yes`' do
      let(:answer) { 'yes' }
      it { is_expected.to have_destination(:litigation_capacity_details, :edit) }
    end

    context 'and the answer is `no`' do
      let(:answer) { 'no' }
      it { is_expected.to have_destination(:intermediary, :edit) }
    end
  end

  context 'when the step is `litigation_capacity_details`' do
    let(:step_params) { { litigation_capacity_details: 'anything' } }
    it { is_expected.to have_destination(:intermediary, :edit) }
  end

  context 'when the step is `intermediary`' do
    let(:step_params) { { intermediary: 'anything' } }
    it { is_expected.to have_destination(:special_assistance, :edit) }
  end

  context 'when the step is `special_assistance`' do
    let(:step_params) { { special_assistance: 'anything' } }
    it { is_expected.to have_destination(:special_arrangements, :edit) }
  end

  context 'when the step is `special_arrangements`' do
    let(:step_params) { { special_arrangements: 'anything' } }

    before do
      allow(subject).to receive(:dev_tools_enabled?).and_return(dev_tools_enabled)
    end

    context 'when dev_tools flag is enabled' do
      let(:dev_tools_enabled) { true }
      it { is_expected.to have_destination(:payment, :edit) }
    end

    context 'when dev_tools flag is disabled' do
      let(:dev_tools_enabled) { false }
      it { is_expected.to have_destination(:help_paying, :edit) }
    end
  end

  context 'when the step is `help_paying`' do
    let(:step_params) { { help_paying: 'anything' } }
    it { is_expected.to have_destination(:check_your_answers, :edit) }
  end

  context 'when the step is `payment`' do
    let(:step_params) { { payment: 'anything' } }
    it { is_expected.to have_destination(:submission, :edit) }
  end

  context 'when the step is `submission`' do
    let(:step_params) { { submission: 'anything' } }

    context 'and the submission_type is online' do
      let(:c100_application){ instance_double(C100Application, submission_type: SubmissionType::ONLINE.to_s) }
      before do
        allow(SendApplicationToCourtJob).to receive(:perform_now)
        allow(c100_application).to receive(:court_from_screener_answers).and_return(
          double('court', email: 'courtemail@example.com')
        )
      end
      it 'queues a job to send the current c100 to the right court' do
        expect(SendApplicationToCourtJob).to receive(:perform_now).with(
          c100_application,
          to: 'courtemail@example.com'
        )
      end
      it { is_expected.to have_destination('/steps/completion/what_next', :show) }
    end
  end

  context 'when the step is `print_and_post_submission`' do
    let(:step_params) { { print_and_post_submission: 'anything' } }
    it { is_expected.to have_destination('/steps/completion/what_next', :show) }
  end

  context 'when the step is `online_submission`' do
    let(:step_params) { { online_submission: 'anything' } }
    it { is_expected.to have_destination('/steps/completion/confirmation', :show) }
  end
end
