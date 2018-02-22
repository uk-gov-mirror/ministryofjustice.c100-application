require 'spec_helper'

module Summary
  describe Sections::C1aSolicitorDetails do
    let(:c100_application) {
      instance_double(C100Application,
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:c1a_solicitor_details) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(1)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:c1a_has_solicitor)
        expect(answers[0].value).to eq(GenericYesNo::NO) # Always `NO` for pilot (we are screening)
      end
    end
  end
end
