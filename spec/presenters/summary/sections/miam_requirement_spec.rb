require 'spec_helper'

module Summary
  describe Sections::MiamRequirement do
    let(:c100_application) {
      instance_double(C100Application,
        child_protection_cases: 'no',
        miam_certification: 'yes',
        miam_attended: 'yes',
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:miam_requirement) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(4)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:miam_child_protection)
        expect(c100_application).to have_received(:child_protection_cases)

        expect(answers[1]).to be_an_instance_of(Answer)
        expect(answers[1].question).to eq(:miam_exemption_claimed)
        expect(answers[1].value).to eq(GenericYesNo::NO) # Always NO for now

        expect(answers[2]).to be_an_instance_of(Answer)
        expect(answers[2].question).to eq(:miam_certificate_received)
        expect(c100_application).to have_received(:miam_certification)

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:miam_attended)
        expect(c100_application).to have_received(:miam_attended)
      end
    end
  end
end
