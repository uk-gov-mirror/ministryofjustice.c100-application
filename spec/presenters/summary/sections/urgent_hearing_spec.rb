require 'spec_helper'

module Summary
  describe Sections::UrgentHearing do
    let(:c100_application) { instance_double(C100Application) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:urgent_hearing) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(1)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:urgent_hearing_details)
        expect(answers[0].value).to eq(GenericYesNo::NO)
      end
    end
  end
end
