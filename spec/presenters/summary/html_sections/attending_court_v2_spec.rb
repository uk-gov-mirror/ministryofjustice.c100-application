require 'spec_helper'

module Summary
  describe HtmlSections::AttendingCourtV2 do
    subject { described_class.new(c100_application) }

    let(:c100_application) {
      instance_double(
        C100Application,
        reduced_litigation_capacity: 'yes',
        participation_capacity_details: 'participation_capacity_details',
        participation_other_factors_details: 'participation_other_factors_details',
        participation_referral_or_assessment_details: 'participation_referral_or_assessment_details',
        court_arrangement: court_arrangement
      )
    }

    let(:court_arrangement) {
      instance_double(CourtArrangement,
        language_interpreter: true,
        language_interpreter_details: 'language_interpreter_details',
        sign_language_interpreter: true,
        sign_language_interpreter_details: 'sign_language_interpreter_details',
        intermediary_help: 'yes',
        intermediary_help_details: 'intermediary_help_details',
        special_arrangements: special_arrangements,
        special_arrangements_details: special_arrangements_details,
        special_assistance: special_assistance,
        special_assistance_details: special_assistance_details,
    )}

    let(:special_arrangements) { ['video_link'] }
    let(:special_arrangements_details) { 'special_arrangements_details' }
    let(:special_assistance) { ['hearing_loop'] }
    let(:special_assistance_details) { 'special_assistance_details' }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:attending_court) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(6)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:reduced_litigation_capacity)
        expect(answers[0].value).to eq('yes')
        expect(answers[0].change_path).to eq('/steps/application/litigation_capacity')

        expect(answers[1]).to be_an_instance_of(AnswersGroup)
        expect(answers[1].name).to eq(:litigation_capacity)
        expect(answers[1].change_path).to eq('/steps/application/litigation_capacity_details')

        expect(answers[2]).to be_an_instance_of(AnswersGroup)
        expect(answers[2].name).to eq(:language_interpreter)
        expect(answers[2].change_path).to eq('/steps/attending_court/language')

        expect(answers[3]).to be_an_instance_of(AnswersGroup)
        expect(answers[3].name).to eq(:intermediary)
        expect(answers[3].change_path).to eq('/steps/attending_court/intermediary')

        expect(answers[4]).to be_an_instance_of(AnswersGroup)
        expect(answers[4].name).to eq(:special_arrangements)
        expect(answers[4].change_path).to eq('/steps/attending_court/special_arrangements')

        expect(answers[5]).to be_an_instance_of(AnswersGroup)
        expect(answers[5].name).to eq(:special_assistance)
        expect(answers[5].change_path).to eq('/steps/attending_court/special_assistance')
      end

      context 'when the special arrangements step has not been visited yet' do
        let(:special_arrangements) { [] }
        let(:special_arrangements_details) { nil }

        it 'does not show the block' do
          expect(answers.count).to eq(5)
        end
      end

      context 'when the special assistance step has not been visited yet' do
        let(:special_assistance) { [] }
        let(:special_assistance_details) { nil }

        it 'does not show the block' do
          expect(answers.count).to eq(5)
        end
      end

      context 'litigation_capacity' do
        let(:group_answers) { answers[1].answers }

        it 'has the correct rows in the right order' do
          expect(group_answers.count).to eq(3)

          expect(group_answers[0]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[0].question).to eq(:participation_capacity_details)
          expect(group_answers[0].value).to eq('participation_capacity_details')

          expect(group_answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[1].question).to eq(:participation_other_factors_details)
          expect(group_answers[1].value).to eq('participation_other_factors_details')

          expect(group_answers[2]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[2].question).to eq(:participation_referral_or_assessment_details)
          expect(group_answers[2].value).to eq('participation_referral_or_assessment_details')
        end
      end

      context 'language_interpreter' do
        let(:group_answers) { answers[2].answers }

        it 'has the correct rows in the right order' do
          expect(group_answers.count).to eq(4)

          expect(group_answers[0]).to be_an_instance_of(Answer)
          expect(group_answers[0].question).to eq(:language_interpreter)
          expect(group_answers[0].value).to eq('true')

          expect(group_answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[1].question).to eq(:language_interpreter_details)
          expect(group_answers[1].value).to eq('language_interpreter_details')

          expect(group_answers[2]).to be_an_instance_of(Answer)
          expect(group_answers[2].question).to eq(:sign_language_interpreter)
          expect(group_answers[2].value).to eq('true')

          expect(group_answers[3]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[3].question).to eq(:sign_language_interpreter_details)
          expect(group_answers[3].value).to eq('sign_language_interpreter_details')
        end
      end

      context 'intermediary' do
        let(:group_answers) { answers[3].answers }

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

      context 'special_arrangements' do
        let(:group_answers) { answers[4].answers }

        it 'has the correct rows in the right order' do
          expect(group_answers.count).to eq(2)

          expect(group_answers[0]).to be_an_instance_of(MultiAnswer)
          expect(group_answers[0].question).to eq(:special_arrangements)
          expect(group_answers[0].value).to eq(['video_link'])

          expect(group_answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[1].question).to eq(:special_arrangements_details)
          expect(group_answers[1].value).to eq('special_arrangements_details')
        end

        context 'when no check boxes were selected' do
          let(:special_arrangements) { [] }

          it 'still shows the block because `show: true` (will use the `absence_answer`)' do
            expect(group_answers.count).to eq(2)

            expect(group_answers[0]).to be_an_instance_of(MultiAnswer)
            expect(group_answers[0].question).to eq(:special_arrangements)
            expect(group_answers[0].value).to eq([])
          end
        end
      end

      context 'special_assistance' do
        let(:group_answers) { answers[5].answers }

        it 'has the correct rows in the right order' do
          expect(group_answers.count).to eq(2)

          expect(group_answers[0]).to be_an_instance_of(MultiAnswer)
          expect(group_answers[0].question).to eq(:special_assistance)
          expect(group_answers[0].value).to eq(['hearing_loop'])

          expect(group_answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[1].question).to eq(:special_assistance_details)
          expect(group_answers[1].value).to eq('special_assistance_details')
        end

        context 'when no check boxes were selected' do
          let(:special_assistance) { [] }

          it 'still shows the block because `show: true` (will use the `absence_answer`)' do
            expect(group_answers.count).to eq(2)

            expect(group_answers[0]).to be_an_instance_of(MultiAnswer)
            expect(group_answers[0].question).to eq(:special_assistance)
            expect(group_answers[0].value).to eq([])
          end
        end
      end
    end
  end
end
