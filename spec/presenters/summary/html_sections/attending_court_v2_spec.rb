require 'spec_helper'

module Summary
  describe HtmlSections::AttendingCourtV2 do
    subject { described_class.new(c100_application) }

    let(:c100_application) { instance_double(C100Application, court_arrangement: court_arrangement) }

    let(:court_arrangement) {
      instance_double(CourtArrangement,
        language_interpreter: true,
        language_interpreter_details: 'language_interpreter_details',
        sign_language_interpreter: true,
        sign_language_interpreter_details: 'sign_language_interpreter_details'
    )}

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:attending_court) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(1)

        expect(answers[0]).to be_an_instance_of(AnswersGroup)
        expect(answers[0].name).to eq(:language_interpreter)
        expect(answers[0].change_path).to eq('/steps/attending_court/language')
      end

      context 'language_interpreter' do
        let(:group_answers) { answers[0].answers }

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
    end
  end
end
