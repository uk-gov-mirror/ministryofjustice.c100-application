require 'spec_helper'

describe Summary::PdfPresenter do
  let(:c100_application) { C100Application.new(address_confidentiality: address_confidentiality) }
  let(:generator) { double('Generator') }

  let(:address_confidentiality) { 'no' }

  subject { described_class.new(c100_application, generator) }

  describe '#generate' do
    it 'generates the C100 form' do
      expect(generator).to receive(:generate).with(
        an_instance_of(Summary::C100Form), copies: 3
      )

      subject.generate
    end

    context 'when C8 is triggered' do
      let(:address_confidentiality) { 'yes' }

      it 'generates the C100 form and the C8' do
        expect(generator).to receive(:generate).with(
          an_instance_of(Summary::C100Form), copies: 3
        )

        expect(generator).to receive(:generate).with(
          an_instance_of(Summary::C8Form), copies: 1
        )

        subject.generate
      end
    end
  end

  describe '#to_pdf' do
    it 'delegates method to the generator' do
      expect(generator).to receive(:to_pdf)
      subject.to_pdf
    end
  end
end
