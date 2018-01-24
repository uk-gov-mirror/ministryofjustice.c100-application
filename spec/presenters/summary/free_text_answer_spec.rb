require 'spec_helper'

describe Summary::FreeTextAnswer do
  let(:question) {'Question?'}
  let(:value) {'Answer!'}
  let(:change_path) {nil}

  subject { described_class.new(question, value, change_path: change_path) }

  describe '#to_partial_path' do
    it 'returns the correct partial path' do
      expect(subject.to_partial_path).to eq('shared/free_text_row')
    end
  end

  describe '#show?' do
    it 'returns true' do
      expect(subject.show?).to eq(true)
    end
  end
end
