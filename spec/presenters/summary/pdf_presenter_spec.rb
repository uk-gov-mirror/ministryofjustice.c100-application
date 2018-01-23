require 'spec_helper'

describe Summary::PdfPresenter do
  let(:c100_application) { instance_double(C100Application) }
  subject { described_class.new(c100_application) }

  describe '#pdf_params' do
    it 'should have the expected parameters' do
      expect(subject.pdf_params).to eq({pdf: 'c100_application', footer: { right: '[page]' }})
    end
  end

  describe '#sections' do
    let(:header_presenter) { double(Summary::Sections::HeaderSection, show?: true) }
    let(:consent_order_presenter) { double(Summary::Sections::ExampleSection, show?: true) }

    before do
      allow(Summary::Sections::HeaderSection).to  receive(:new).with(c100_application, name: :c100_form).and_return(header_presenter)
      allow(Summary::Sections::ExampleSection).to receive(:new).with(c100_application).and_return(consent_order_presenter)
    end

    it 'has the right sections in the right order' do
      expect(subject.sections.count).to eq(2)
      expect(subject.sections).to eq(
        [
          header_presenter,
          consent_order_presenter,
        ]
      )
    end
  end
end
