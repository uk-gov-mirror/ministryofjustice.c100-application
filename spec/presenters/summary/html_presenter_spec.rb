require 'spec_helper'

describe Summary::HtmlPresenter do
  let(:c100_application) { instance_double(C100Application) }
  subject { described_class.new(c100_application) }

  describe '#sections' do
    let(:consent_order_presenter) { double(Summary::Sections::ExampleSection, show?: true) }

    before do
      allow(Summary::Sections::ExampleSection).to receive(:new).with(c100_application).and_return(consent_order_presenter)
    end

    it 'has the right sections in the right order' do
      expect(subject.sections.count).to eq(1)

      expect(subject.sections[0]).to eq(consent_order_presenter)
    end
  end
end
