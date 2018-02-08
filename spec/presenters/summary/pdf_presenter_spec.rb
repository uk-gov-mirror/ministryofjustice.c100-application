require 'spec_helper'

describe Summary::PdfPresenter do
  let(:c100_application) { instance_double(C100Application) }
  let(:generator) { double('Generator') }

  subject { described_class.new(c100_application, generator) }

  describe '#generate' do
    it 'generates the different form documents needed' do
      expect(generator).to receive(:generate).with(
        an_instance_of(Summary::C100Form), copies: 3
      )

      subject.generate
    end
  end

  describe '#to_pdf' do
    it 'delegates method to the generator' do
      expect(generator).to receive(:to_pdf)
      subject.to_pdf
    end
  end
end
