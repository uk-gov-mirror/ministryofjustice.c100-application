require 'spec_helper'

module Summary
  describe C100Form do
    let(:c100_application) { instance_double(C100Application) }
    subject { described_class.new(c100_application) }

    describe '#tempate' do
      it { expect(subject.template).to eq('steps/completion/summary/show.pdf') }
    end

    describe '#sections' do
      before do
        allow_any_instance_of(Summary::Sections::BaseSectionPresenter).to receive(:show?).and_return(true)
      end

      it 'has the right sections in the right order' do
        expect(subject.sections).to match_instances_array([
          Sections::FormHeader,
          Sections::HelpWithFees,
          Sections::ApplicantRespondent,
          Sections::NatureOfApplication,
          Sections::RiskConcerns,
          Sections::AdditionalInformation,
          Sections::SectionHeader,
          Sections::ChildrenDetails,
          Sections::ChildrenRelationships,
          Sections::SectionHeader,
          Sections::MiamRequirement,
          Sections::SectionHeader,
          Sections::MediatorCertification,
          Sections::SectionHeader,
          Sections::ApplicationReasons,
          Sections::SectionHeader,
          Sections::UrgentHearing,
          Sections::WithoutNoticeHearing,
          Sections::SectionHeader,
          Sections::InternationalElement,
          Sections::SectionHeader,
          Sections::LitigationCapacity,
          Sections::SectionHeader,
          Sections::AttendingCourt,
          Sections::SectionHeader,
          Sections::ApplicantsDetails,
          Sections::SectionHeader,
          Sections::RespondentsDetails,
          Sections::SectionHeader,
          Sections::OtherPartiesDetails,
          Sections::OtherChildrenDetails,
          Sections::SectionHeader,
          Sections::SolicitorDetails,
        ])
      end
    end
  end
end
