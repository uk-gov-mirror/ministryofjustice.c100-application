require 'spec_helper'

module Summary
  describe Sections::C8CourtDetails do
    let(:c100_application) { instance_double(C100Application, children: [child]) }
    subject { described_class.new(c100_application) }

    let(:child) { instance_double(Child, full_name: 'John Doe') }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:c8_court_details)
      end
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(5)

        expect(answers[0]).to be_an_instance_of(AnswerBox)
        expect(answers[0].question).to eq(:c8_family_court)

        expect(answers[1]).to be_an_instance_of(AnswerBox)
        expect(answers[1].question).to eq(:c8_case_number)

        expect(answers[2]).to be_an_instance_of(Partial)
        expect(answers[2].name).to eq(:blank_space)

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:c8_children_names)
        expect(answers[3].value).to eq(:c8_children_numbers)

        expect(answers[4]).to be_an_instance_of(AnswerBox)
        expect(answers[4].question).to eq('John Doe')
      end
    end
  end
end
