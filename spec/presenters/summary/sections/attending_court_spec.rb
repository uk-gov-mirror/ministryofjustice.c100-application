require 'spec_helper'

module Summary
  describe Sections::AttendingCourt do
    let(:c100_application) {
      instance_double(C100Application,
        special_assistance: 'yes',
        special_assistance_details: 'assistance_details',
        special_arrangements: 'yes',
        special_arrangements_details: 'arrangements_details',
        language_help: 'yes',
        language_help_details: 'language_help_details',
        intermediary_help: 'yes',
        intermediary_help_details: 'intermediary_help_details',
        court_arrangement: court_arrangement,
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }
    let(:court_arrangement) { nil }

    describe '#name' do
      it { expect(subject.name).to eq(:attending_court) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#show?' do
      context 'when not using the new special court arrangement details' do
        let(:court_arrangement) { nil }

        it 'returns true (we use this class, `AttendingCourt`)' do
          expect(subject.show?).to eq(true)
        end
      end

      context 'when using the new special court arrangement details' do
        let(:court_arrangement) { double }

        it 'returns false (we use the new class, `AttendingCourtV2`)' do
          expect(subject.show?).to eq(false)
        end
      end
    end

    # The following tests can be fragile, but on purpose. During the development phase
    # we have to update the tests each time we introduce a new row or remove another.
    # But once it is finished and stable, it will raise a red flag if it ever gets out
    # of sync, which means a quite solid safety net for any maintainers in the future.
    #
    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(11)

        expect(answers[0]).to be_an_instance_of(Separator)
        expect(answers[0].title).to eq(:language_assistance)

        expect(answers[1].question).to eq(:language_help)
        expect(answers[1].value).to eq('yes')

        expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[2].question).to eq(:language_help_details)
        expect(answers[2].value).to eq('language_help_details')

        expect(answers[3]).to be_an_instance_of(Separator)
        expect(answers[3].title).to eq(:intermediary)

        expect(answers[4].question).to eq(:intermediary_help)
        expect(answers[4].value).to eq('yes')

        expect(answers[5]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[5].question).to eq(:intermediary_help_details)
        expect(answers[5].value).to eq('intermediary_help_details')

        expect(answers[6]).to be_an_instance_of(Separator)
        expect(answers[6].title).to eq(:special_assistance)

        expect(answers[7]).to be_an_instance_of(Answer)
        expect(answers[7].question).to eq(:special_assistance)
        expect(answers[7].value).to eq('yes')

        expect(answers[8]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[8].question).to eq(:special_assistance_details)
        expect(answers[8].value).to eq('assistance_details')

        expect(answers[9]).to be_an_instance_of(Answer)
        expect(answers[9].question).to eq(:special_arrangements)
        expect(answers[9].value).to eq('yes')

        expect(answers[10]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[10].question).to eq(:special_arrangements_details)
        expect(answers[10].value).to eq('arrangements_details')
      end
    end
  end
end
