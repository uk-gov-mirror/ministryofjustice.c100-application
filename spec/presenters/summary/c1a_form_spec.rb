require 'spec_helper'

module Summary
  describe C1aForm do
    let(:c100_application) { instance_double(C100Application, court_arrangement: court_arrangement) }
    let(:court_arrangement) { nil }

    subject { described_class.new(c100_application) }

    describe '#name' do
      it { expect(subject.name).to eq('C1A') }
    end

    describe '#template' do
      it { expect(subject.template).to eq('steps/completion/summary/show.pdf') }
    end

    describe '#raw_file_path' do
      it { expect(subject.raw_file_path).to eq('app/assets/docs/c1a_page9.en.pdf') }
    end

    describe '#sections' do
      before do
        allow_any_instance_of(Summary::Sections::BaseSectionPresenter).to receive(:show?).and_return(true)
      end

      it 'has the right sections in the right order' do
        expect(subject.sections).to match_instances_array([
          Sections::FormHeader,
          Sections::C1aCourtDetails,
          Sections::SectionHeader,
          Sections::C1aApplicantDetails,
          Sections::C1aChildrenDetails,
          Sections::C1aSolicitorDetails,
          Sections::SectionHeader,
          Sections::C1aChildrenAbuseSummary,
          Sections::C1aApplicantAbuseSummary,
          Sections::C1aCourtOrders,
          Sections::C1aConcernsSubstance,
          Sections::C1aChildrenAbuseDetails,
          Sections::C1aApplicantAbuseDetails,
          Sections::SectionHeader,
          Sections::C1aAbductionDetails,
          Sections::SectionHeader,
          Sections::C1aChildrenOtherAbuseDetails,
          Sections::SectionHeader,
          Sections::C1aProtectionOrders,
          Sections::SectionHeader,
          Sections::StatementOfTruth,
          Sections::SectionHeader,
          Sections::AttendingCourt,
          Sections::C1aGettingSupport,
        ])
      end

      context 'when not using the new special court arrangement details' do
        it 'does not include the `AttendingCourtV2` section' do
          expect(subject.sections).not_to include(Sections::AttendingCourtV2)
        end

        it 'includes the `AttendingCourt` section' do
          expect(subject.sections).to include(Sections::AttendingCourt)
        end
      end

      context 'when using the new special court arrangement details' do
        let(:court_arrangement) { instance_double(CourtArrangement) }

        it 'includes the `AttendingCourtV2` section' do
          expect(subject.sections).to include(Sections::AttendingCourtV2)
        end

        it 'does not include the `AttendingCourt` section' do
          expect(subject.sections).not_to include(Sections::AttendingCourt)
        end
      end
    end
  end
end
