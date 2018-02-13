require 'spec_helper'

module Summary
  describe Sections::ChildrenResidence do
    let(:c100_application) {
      instance_double(C100Application,
        children: [],
      )
    }

    let(:residence) { instance_double(ChildResidence) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:children_residence)
      end
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#answers' do
      before do
        # This is a quick smoke test, not in deep, as we will probably need to change the
        # implementation of the residence_full_names method once the PDF mockup is finished.
        allow(ChildResidence).to receive(:where).and_return([residence])
        allow(subject).to receive(:residence_full_names).with(residence).and_return('Full name')
      end

      it 'has the correct number of rows' do
        expect(answers.count).to eq(1)
      end

      it 'has the correct rows in the right order' do
        expect(c100_application).to receive(:children)

        expect(answers[0]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[0].question).to eq(:children_residence)
        expect(answers[0].value).to eq('Full name')
        expect(subject).to have_received(:residence_full_names)
      end
    end
  end
end
