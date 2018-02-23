require 'spec_helper'

module Summary
  describe C1aForm do
    let(:c100_application) { instance_double(C100Application) }
    subject { described_class.new(c100_application) }

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
          Sections::C1aApplicantAbuseDetails,
          Sections::C1aChildrenAbuseDetails,
          Sections::C1aCourtOrders,
        ])
      end
    end
  end
end
