require 'spec_helper'

describe Summary::HtmlPresenter do
  let(:c100_application) { instance_double(C100Application) }
  subject { described_class.new(c100_application) }

  describe '#sections' do
    before do
      allow_any_instance_of(Summary::Sections::BaseSectionPresenter).to receive(:show?).and_return(true)
    end

    it 'has the right sections in the right order' do
      expect(subject.sections).to match_instances_array([
        Summary::HtmlSections::ChildProtectionCases,
        Summary::HtmlSections::MiamRequirement,
      ])
    end
  end
end
