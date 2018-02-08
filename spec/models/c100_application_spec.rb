require 'rails_helper'

RSpec.describe C100Application, type: :model do
  subject { described_class.new(attributes) }
  let(:attributes) { {} }

  describe '#confidentiality_enabled?' do
    context 'for `yes` values' do
      let(:attributes) { {address_confidentiality: 'yes'} }
      it { expect(subject.confidentiality_enabled?).to eq(true) }
    end

    context 'for `no` values' do
      let(:attributes) { {address_confidentiality: 'no'} }
      it { expect(subject.confidentiality_enabled?).to eq(false) }
    end
  end
end
