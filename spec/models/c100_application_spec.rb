require 'rails_helper'

RSpec.describe C100Application, type: :model do
  subject { described_class.new(attributes) }
  let(:attributes) { {} }

  describe 'status enum' do
    it 'has the right values' do
      expect(
        described_class.statuses
      ).to eq(
        'screening' => 0,
        'in_progress' => 1,
        'first_reminder_sent' => 5,
        'last_reminder_sent' => 6,
        'completed' => 10,
      )
    end
  end

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

  describe '#has_safety_concerns?' do
    let(:attributes) { {
      domestic_abuse: domestic_abuse,
      risk_of_abduction: 'no',
      children_abuse: 'no',
      substance_abuse: 'no',
      other_abuse: 'no'
    } }

    context 'at least one concern was answered as `YES`' do
      let(:domestic_abuse) { 'yes' }
      it { expect(subject.has_safety_concerns?).to eq(true) }
    end

    context 'there are no concerns' do
      let(:domestic_abuse) { 'no' }
      it { expect(subject.has_safety_concerns?).to eq(false) }

      it 'checks all the neccessary attributes' do
        expect(subject).to receive(:domestic_abuse)
        expect(subject).to receive(:risk_of_abduction)
        expect(subject).to receive(:children_abuse)
        expect(subject).to receive(:substance_abuse)
        expect(subject).to receive(:other_abuse)

        subject.has_safety_concerns?
      end
    end
  end
end
