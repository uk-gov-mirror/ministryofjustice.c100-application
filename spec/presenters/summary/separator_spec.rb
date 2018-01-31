require 'spec_helper'

describe Summary::Separator do
  let(:title) { :whatever }

  subject { described_class.new(title) }

  describe '#show?' do
    it { expect(subject.show?).to eq(true) }
  end

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('shared/separator') }
  end

  describe 'can be given i18n options' do
    context 'when there are no options' do
      it 'returns the default value' do
        expect(subject.i18n_opts).to eq({})
      end
    end

    context 'when there are options' do
      subject { described_class.new(title, index: 1) }

      it 'returns the options' do
        expect(subject.i18n_opts).to eq({index: 1})
      end
    end
  end
end
