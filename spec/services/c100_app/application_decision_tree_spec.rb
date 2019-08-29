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
      it { is_expected.to have_destination(:urgent_hearing, :edit) }
    end
  end

  context 'when the step is `court_proceedings`' do
    let(:step_params) { { court_proceedings: 'anything' } }
    it { is_expected.to have_destination(:urgent_hearing, :edit) }
  end

  context 'when the step is `urgent_hearing`' do
    let(:c100_application) { instance_double(C100Application, urgent_hearing: answer) }
    let(:step_params) { { urgent_hearing: 'whatever' } }

    context 'and the answer is `yes`' do
      let(:answer) { 'yes' }
      it { is_expected.to have_destination(:urgent_hearing_details, :edit) }
    end

    context 'and the answer is `no`' do
      let(:answer) { 'no' }
      it { is_expected.to have_destination(:without_notice, :edit) }
    end
  end

  context 'when the step is `urgent_hearing_details`' do
    let(:step_params) { { urgent_hearing_details: 'anything' } }
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
    it { is_expected.to have_destination(:payment, :edit) }
  end

  context 'when the step is `payment`' do
    let(:step_params) { { payment: 'anything' } }
    it { is_expected.to have_destination(:submission, :edit) }
  end

  context 'when the step is `submission`' do
    let(:step_params) { { submission: 'anything' } }
    let(:c100_application) { instance_double(C100Application, receipt_email: receipt_email) }

    context 'and user chose to receive a confirmation email' do
      let(:receipt_email) { 'test@example.com' }
      it { is_expected.to have_destination(:receipt_email_check, :show) }
    end

    context 'and user left blank the confirmation email' do
      let(:receipt_email) { '' }
      it { is_expected.to have_destination(:check_your_answers, :edit) }
    end

    context 'and user do not want online submission' do
      let(:receipt_email) { nil }
      it { is_expected.to have_destination(:check_your_answers, :edit) }
    end
  end

  context 'when the step is `declaration`' do
    let(:c100_application) { C100Application.new(submission_type: submission_type) }
    let(:step_params) { { declaration: 'anything' } }

    context 'and the submission_type is online' do
      let(:submission_type) { SubmissionType::ONLINE }
      let(:queue) { double.as_null_object }

      before do
        allow(C100App::OnlineSubmissionQueue).to receive(:new).and_return(queue)
      end

      it { is_expected.to have_destination('/steps/completion/confirmation', :show) }

      it 'process the application online submission' do
        expect(C100App::OnlineSubmissionQueue).to receive(:new).with(c100_application).and_return(queue)
        expect(queue).to receive(:process)

        subject.destination
      end
    end

    context 'and the submission_type is print and post' do
      let(:submission_type) { SubmissionType::PRINT_AND_POST }

      it { is_expected.to have_destination('/steps/completion/what_next', :show) }

      it 'does not process the application online submission' do
        expect(C100App::OnlineSubmissionQueue).not_to receive(:new)
        subject.destination
      end
    end
  end
end
