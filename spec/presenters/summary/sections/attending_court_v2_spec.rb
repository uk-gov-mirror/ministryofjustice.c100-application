require 'spec_helper'

module Summary
  describe Sections::AttendingCourtV2 do
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

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#show?' do
      context 'when not using the new special court arrangement details' do
        let(:court_arrangement) { nil }

        it 'returns true (we use this class, `AttendingCourt`)' do
          expect(subject.show?).to eq(false)
        end
      end

      context 'when using the new special court arrangement details' do
        it 'returns false (we use the new class, `AttendingCourtV2`)' do
          expect(subject.show?).to eq(true)
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
        expect(answers.count).to eq(5)

        expect(answers[0]).to be_an_instance_of(Separator)
        expect(answers[0].title).to eq(:language_assistance)

        expect(answers[1].question).to eq(:language_interpreter)
        expect(answers[1].value).to eq('true')

        expect(answers[2].question).to eq(:language_interpreter_details)
        expect(answers[2].value).to eq('language_interpreter_details')

        expect(answers[3].question).to eq(:sign_language_interpreter)
        expect(answers[3].value).to eq('true')

        expect(answers[4].question).to eq(:sign_language_interpreter_details)
        expect(answers[4].value).to eq('sign_language_interpreter_details')
      end
    end
  end
end
