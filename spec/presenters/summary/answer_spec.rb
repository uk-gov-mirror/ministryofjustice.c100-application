require 'spec_helper'

describe Summary::Answer do
  let(:question) {'Question?'}
  let(:value) {'Answer!'}
  let(:change_path) {nil}

  subject { described_class.new(question, value, change_path: change_path) }

  describe '#to_partial_path' do
    it 'returns the correct partial path' do
      expect(subject.to_partial_path).to eq('shared/row')
    end
  end

  describe '#show?' do
    it 'returns true' do
      expect(subject.show?).to eq(true)
    end

    context 'when no value is given' do
      let(:value) {nil}

      it 'returns false' do
        expect(subject.show?).to eq(false)
      end
    end
  end

  describe '#value?' do
    it 'returns true' do
      expect(subject.value?).to eq(true)
    end

    context 'when no value is given' do
      let(:value) {nil}

      it 'returns false' do
        expect(subject.value?).to eq(false)
      end
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
