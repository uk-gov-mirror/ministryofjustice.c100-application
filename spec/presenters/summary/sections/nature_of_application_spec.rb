require 'spec_helper'

module Summary
  describe Sections::NatureOfApplication do
    let(:c100_application) { instance_double(C100Application, asking_order: asking_order) }
    subject { described_class.new(c100_application) }

    let(:asking_order) { double('asking_order').as_null_object }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:nature_of_application)
      end
    end

    describe '#answers' do
      before do
        allow(asking_order).to receive(:other_details).and_return('description')
      end

      it 'has the correct number of rows' do
        expect(answers.count).to eq(4)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(MultiAnswer)
        expect(answers[0].question).to eq(:child_arrangements_orders)

        expect(answers[1]).to be_an_instance_of(MultiAnswer)
        expect(answers[1].question).to eq(:specific_issues_orders)

        expect(answers[2]).to be_an_instance_of(MultiAnswer)
        expect(answers[2].question).to eq(:prohibited_steps_orders)

        expect(answers[3]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[3].question).to eq(:other_details)
      end
    end
  end
end
