require 'spec_helper'

module Summary
  describe HtmlSections::AttendingCourt do
    let(:c100_application) {
      instance_double(C100Application,
        intermediary_help: 'yes',
        intermediary_help_details: 'intermediary_help_details',
        language_help: 'yes',
        language_help_details: 'language_help_details',
        special_assistance: 'yes',
        special_assistance_details: 'special_assistance_details',
        special_arrangements: 'yes',
        special_arrangements_details: 'special_arrangements_details',
        court_arrangement: court_arrangement,
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }
    let(:court_arrangement) { nil }

    describe '#name' do
      it { expect(subject.name).to eq(:attending_court) }
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

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(4)

        expect(answers[0]).to be_an_instance_of(AnswersGroup)
        expect(answers[0].name).to eq(:intermediary)
        expect(answers[0].change_path).to eq('/steps/application/intermediary')

        expect(answers[1]).to be_an_instance_of(AnswersGroup)
        expect(answers[1].name).to eq(:language_help)
        expect(answers[1].change_path).to eq('/steps/application/language')

        expect(answers[2]).to be_an_instance_of(AnswersGroup)
        expect(answers[2].name).to eq(:special_arrangements)
        expect(answers[2].change_path).to eq('/steps/application/special_arrangements')

        expect(answers[3]).to be_an_instance_of(AnswersGroup)
        expect(answers[3].name).to eq(:special_assistance)
        expect(answers[3].change_path).to eq('/steps/application/special_assistance')
      end

      context 'intermediary' do
        let(:group_answers) { answers[0].answers }

        it 'has the correct rows in the right order' do
          expect(group_answers.count).to eq(2)

          expect(group_answers[0]).to be_an_instance_of(Answer)
          expect(group_answers[0].question).to eq(:intermediary_help)
          expect(group_answers[0].value).to eq('yes')

          expect(group_answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[1].question).to eq(:intermediary_help_details)
          expect(group_answers[1].value).to eq('intermediary_help_details')
        end
      end

      context 'language_assistance' do
        let(:group_answers) { answers[1].answers }

        it 'has the correct rows in the right order' do
          expect(group_answers.count).to eq(2)

          expect(group_answers[0]).to be_an_instance_of(Answer)
          expect(group_answers[0].question).to eq(:language_help)
          expect(group_answers[0].value).to eq('yes')

          expect(group_answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[1].question).to eq(:language_help_details)
          expect(group_answers[1].value).to eq('language_help_details')
        end
      end

      context 'special_arrangements' do
        let(:group_answers) { answers[2].answers }

        it 'has the correct rows in the right order' do
          expect(group_answers.count).to eq(2)

          expect(group_answers[0]).to be_an_instance_of(Answer)
          expect(group_answers[0].question).to eq(:special_arrangements)
          expect(group_answers[0].value).to eq('yes')

          expect(group_answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[1].question).to eq(:special_arrangements_details)
          expect(group_answers[1].value).to eq('special_arrangements_details')
        end
      end

      context 'special_assistance' do
        let(:group_answers) { answers[3].answers }

        it 'has the correct rows in the right order' do
          expect(group_answers.count).to eq(2)

          expect(group_answers[0]).to be_an_instance_of(Answer)
          expect(group_answers[0].question).to eq(:special_assistance)
          expect(group_answers[0].value).to eq('yes')

          expect(group_answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[1].question).to eq(:special_assistance_details)
          expect(group_answers[1].value).to eq('special_assistance_details')
        end
      end
    end
  end
end
