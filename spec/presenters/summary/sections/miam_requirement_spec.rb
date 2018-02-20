require 'spec_helper'

module Summary
  describe Sections::MiamRequirement do
    let(:c100_application) {
      instance_double(C100Application,
        child_protection_cases: 'no',
        miam_exemption_claim: 'no',
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

    # The following tests can be fragile, but on purpose. During the development phase
    # we have to update the tests each time we introduce a new row or remove another.
    # But once it is finished and stable, it will raise a red flag if it ever gets out
    # of sync, which means a quite solid safety net for any maintainers in the future.
    #
    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(5)

        expect(answers[0]).to be_an_instance_of(Partial)
        expect(answers[0].name).to eq(:miam_information)

        expect(answers[1]).to be_an_instance_of(Answer)
        expect(answers[1].question).to eq(:miam_child_protection)
        expect(answers[1].value).to eq('no')

        expect(answers[2]).to be_an_instance_of(Answer)
        expect(answers[2].question).to eq(:miam_exemption_claim)
        expect(answers[2].value).to eq('no')

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:miam_certificate_received)
        expect(answers[3].value).to eq('yes')

        expect(answers[4]).to be_an_instance_of(Answer)
        expect(answers[4].question).to eq(:miam_attended)
        expect(answers[4].value).to eq('yes')
      end

      context 'uses the default when value is `nil`' do
        let(:c100_application) {
          instance_double(C100Application,
            child_protection_cases: nil,
            miam_exemption_claim: nil,
            miam_certification: nil,
            miam_attended: nil,
          ) }

        it 'has the correct rows' do
          expect(answers.count).to eq(5)

          expect(answers[0]).to be_an_instance_of(Partial)
          expect(answers[0].name).to eq(:miam_information)

          expect(answers[1]).to be_an_instance_of(Answer)
          expect(answers[1].question).to eq(:miam_child_protection)
          expect(answers[1].value).to eq(GenericYesNo::NO)

          expect(answers[2]).to be_an_instance_of(Answer)
          expect(answers[2].question).to eq(:miam_exemption_claim)
          expect(answers[2].value).to eq(GenericYesNo::NO)

          expect(answers[3]).to be_an_instance_of(Answer)
          expect(answers[3].question).to eq(:miam_certificate_received)
          expect(answers[3].value).to eq(GenericYesNo::NO)

          expect(answers[4]).to be_an_instance_of(Answer)
          expect(answers[4].question).to eq(:miam_attended)
          expect(answers[4].value).to eq(GenericYesNo::NO)
        end
      end
    end
  end
end
