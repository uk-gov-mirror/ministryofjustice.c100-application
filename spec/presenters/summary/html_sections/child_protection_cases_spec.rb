require 'spec_helper'

module Summary
  describe HtmlSections::ChildProtectionCases do
    let(:c100_application) { instance_double(C100Application, child_protection_cases: 'yes') }
    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:child_protection_cases) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(1)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:child_protection_cases)
        expect(answers[0].value).to eq('yes')
      end
    end
  end
end
