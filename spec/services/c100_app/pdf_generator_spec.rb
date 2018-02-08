require 'rails_helper'

RSpec.describe C100App::PdfGenerator do
  let(:wicked_pdf) { instance_double(WickedPdf) }
  let(:combiner)   { [] }

  before do
    allow(WickedPdf).to receive(:new).and_return(wicked_pdf)
    allow(CombinePDF).to receive(:new).and_return(combiner)
  end

  describe '#generate' do
    let(:presenter) { double('Presenter', template: 'path/to/template') }
    let(:document)  { 'a form document' }

    it 'renders a form using a presenter' do
      expect(ApplicationController).to receive(:render).with(
        template: 'path/to/template', locals: { presenter: presenter }
      ).and_return(document)

      expect(wicked_pdf).to receive(:pdf_from_string).with(
        document, { footer: { right: '[page]/[topage]' } }
      ).and_return(document)

      # Using 0 copies just to make this test scenario simpler to mock,
      # as we want to test here only the call to `pdf_from_presenter`
      subject.generate(presenter, copies: 0)
    end

    it 'generates a PDF document with N copies' do
      expect(subject).to receive(:pdf_from_presenter).with(presenter).and_return(document)
      expect(CombinePDF).to receive(:parse).twice.with(document).and_return(document)

      subject.generate(presenter, copies: 2)

      expect(combiner).to match_array([document, document])
    end
  end

  describe '#to_pdf' do
    let(:combiner) { double.as_null_object }

    it 'delegates method to combiner' do
      expect(combiner).to receive(:to_pdf)
      subject.to_pdf
    end
  end
end
