require 'spec_helper'

describe Summary::Partial do
  let(:name) { 'anything' }

  subject { described_class.new(name) }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('steps/completion/shared/anything') }
  end

  describe '#show?' do
    it { expect(subject.show?).to eq(true) }
  end

  describe '.page_break' do
    it 'instantiate a Partial object with a specific partial name' do
      partial = described_class.page_break
      expect(partial.name).to eq(:page_break)
    end
  end

  describe '.row_blank_space' do
    it 'instantiate a Partial object with a specific partial name' do
      partial = described_class.row_blank_space
      expect(partial.name).to eq(:row_blank_space)
    end
  end
end
