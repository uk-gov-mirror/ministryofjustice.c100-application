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
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:attending_court) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(9)

        expect(answers[0]).to be_an_instance_of(Separator)
        expect(answers[0].title).to eq(:language_assistance)

        expect(answers[1].question).to eq(:language_help)
        expect(answers[1].value).to eq('yes')

        expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[2].question).to eq(:language_help_details)
        expect(answers[2].value).to eq('language_help_details')

        expect(answers[3]).to be_an_instance_of(Separator)
        expect(answers[3].title).to eq(:intermediary)

        expect(answers[4]).to be_an_instance_of(Separator)
        expect(answers[4].title).to eq(:special_assistance)

        expect(answers[5]).to be_an_instance_of(Answer)
        expect(answers[5].question).to eq(:special_assistance)
        expect(answers[5].value).to eq('yes')

        expect(answers[6]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[6].question).to eq(:special_assistance_details)
        expect(answers[6].value).to eq('assistance_details')

        expect(answers[7]).to be_an_instance_of(Answer)
        expect(answers[7].question).to eq(:special_arrangements)
        expect(answers[7].value).to eq('yes')

        expect(answers[8]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[8].question).to eq(:special_arrangements_details)
        expect(answers[8].value).to eq('arrangements_details')
      end
    end
  end
end
