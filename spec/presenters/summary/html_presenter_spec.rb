require 'spec_helper'

describe Summary::HtmlPresenter do
  let(:c100_application) { instance_double(C100Application) }
  subject { described_class.new(c100_application) }

  describe '#before_submit_warning' do
    let(:c100_application) { instance_double(C100Application, submission_type: submission_type) }

    context 'for online submissions' do
      let(:submission_type) { 'online' }
      it { expect(subject.before_submit_warning).to eq('.submit_warning.online') }
    end

    context 'for print and post submissions' do
      let(:submission_type) { 'print_and_post' }
      it { expect(subject.before_submit_warning).to eq('.submit_warning.print_and_post') }
    end

    context 'defaults to print and post if `submission_type` is not present' do
      let(:submission_type) { nil }
      it { expect(subject.before_submit_warning).to eq('.submit_warning.print_and_post') }
    end
  end

  describe '#submit_button_label' do
    let(:c100_application) { instance_double(C100Application, submission_type: submission_type) }

    context 'for online submissions' do
      let(:submission_type) { 'online' }
      it { expect(subject.submit_button_label).to eq('submit_application.online') }
    end

    context 'for print and post submissions' do
      let(:submission_type) { 'print_and_post' }
      it { expect(subject.submit_button_label).to eq('submit_application.print_and_post') }
    end

    context 'defaults to print and post if `submission_type` is not present' do
      let(:submission_type) { nil }
      it { expect(subject.submit_button_label).to eq('submit_application.print_and_post') }
    end
  end

  describe '#sections' do
    before do
      allow_any_instance_of(Summary::Sections::BaseSectionPresenter).to receive(:show?).and_return(true)

      # Abduction section
      allow(c100_application).to receive(:abduction_detail).and_return(AbductionDetail.new)

      # Help with fees or Payment section (temporary feature-flagged code)
      allow(c100_application).to receive(:payment_type).and_return(nil)
    end

    it 'has the right sections in the right order' do
      expect(subject.sections).to match_instances_array([
        Summary::HtmlSections::MiamRequirement,
        Summary::HtmlSections::MiamAttendance,
        Summary::HtmlSections::MiamExemptions,
        Summary::HtmlSections::SafetyConcerns,
        Summary::HtmlSections::Abduction,
        Summary::HtmlSections::ChildrenAbuseDetails,
        Summary::HtmlSections::ApplicantAbuseDetails,
        Summary::HtmlSections::CourtOrders,
        Summary::HtmlSections::SafetyContact,
        Summary::HtmlSections::NatureOfApplication,
        Summary::HtmlSections::Alternatives,
        Summary::HtmlSections::ChildrenDetails,
        Summary::HtmlSections::ChildrenFurtherInformation,
        Summary::HtmlSections::OtherChildrenDetails,
        Summary::HtmlSections::ApplicantsDetails,
        Summary::HtmlSections::RespondentsDetails,
        Summary::HtmlSections::OtherPartiesDetails,
        Summary::HtmlSections::ChildrenResidence,
        Summary::HtmlSections::OtherCourtCases,
        Summary::HtmlSections::WithoutNoticeDetails,
        Summary::HtmlSections::InternationalElement,
        Summary::HtmlSections::ApplicationReasons,
        Summary::HtmlSections::AttendingCourt,
        Summary::HtmlSections::HelpWithFees,
      ])
    end

    # TODO: temporary feature-flagged code
    context 'when the payment type question has been answered' do
      before do
        allow(c100_application).to receive(:payment_type).and_return('whatever')
      end

      it 'presents the Payment and Submission sections instead of the HelpWithFees section' do
        expect(subject.sections).not_to include(Summary::HtmlSections::HelpWithFees)
        expect(subject.sections).to include(Summary::HtmlSections::Payment)
        expect(subject.sections).to include(Summary::HtmlSections::Submission)
      end
    end
  end
end
