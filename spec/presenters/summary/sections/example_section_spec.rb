require 'spec_helper'

module Summary
  describe Sections::ExampleSection do
    let(:c100_application) { instance_double(C100Application, consent_order: 'whatever') }
    subject { described_class.new(c100_application) }

    let(:answer) { instance_double(Answer, show?: true) }

    before do
      allow(Answer).to receive(:new).and_return(answer)
    end

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:example_section)
      end
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(subject.answers.count).to eq(1)

        expect(subject.answers[0]).to eq(answer)
      end
    end
  end
end
