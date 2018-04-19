require 'spec_helper'

describe Summary::AnswersGroup do
  let(:questions) { [
    question1,
    question2,
  ] }
  let(:change_path) { nil }

  let(:question1) { double('question1') }
  let(:question2) { double('question2') }

  subject { described_class.new(:group_name, questions, change_path: change_path) }

  describe '#name' do
    it { expect(subject.name).to eq(:group_name) }
  end

  describe '#to_partial_path' do
    it 'returns the correct partial path' do
      expect(subject.to_partial_path).to eq('steps/completion/shared/answers_group')
    end
  end

  describe '#show?' do
    it 'calls `show?` on the questions and return true if any question should be shown' do
      expect(question1).to receive(:show?).and_return(false)
      expect(question2).to receive(:show?).and_return(true)
      expect(subject.show?).to eq(true)
    end
  end

  describe '#show_change_link?' do
    it 'returns false' do
      expect(subject.show_change_link?).to eq(false)
    end

    context 'when change_path is given' do
      let(:change_path) {'/change'}

      it 'returns true' do
        expect(subject.show_change_link?).to eq(true)
      end
    end
  end
end
