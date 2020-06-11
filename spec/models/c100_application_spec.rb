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
        'payment_in_progress' => 8,
        'completed' => 10,
      )
    end
  end

  describe 'reminder_status enum' do
    it 'has the right values' do
      expect(
        described_class.reminder_statuses
      ).to eq(
        'first_reminder_sent' => 'first_reminder_sent',
        'last_reminder_sent' => 'last_reminder_sent',
      )
    end
  end

  describe '.purge!' do
    let(:finder_double) { double.as_null_object }

    before do
      travel_to Time.now
    end

    it 'picks records equal to or older than the passed-in date' do
      expect(described_class).to receive(:where).with(
        'c100_applications.created_at <= :date', date: 28.days.ago
      ).and_return(finder_double)

      described_class.purge!(28.days.ago)
    end

    it 'calls #destroy_all on the records it finds' do
      allow(described_class).to receive(:where).and_return(finder_double)
      expect(finder_double).to receive(:destroy_all)

      described_class.purge!(28.days.ago)
    end
  end

  describe '#online_submission?' do
    context 'for `online` values' do
      let(:attributes) { {submission_type: 'online'} }
      it { expect(subject.online_submission?).to eq(true) }
    end

    context 'for other values' do
      let(:attributes) { {submission_type: 'whatever'} }
      it { expect(subject.online_submission?).to eq(false) }
    end
  end

  describe '#online_payment?' do
    context 'for `online` values' do
      let(:attributes) { {payment_type: 'self_payment_card'} }
      it { expect(subject.online_payment?).to eq(true) }
    end

    context 'for other values' do
      let(:attributes) { {payment_type: 'whatever'} }
      it { expect(subject.online_payment?).to eq(false) }
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

  describe '#has_solicitor?' do
    context 'for a `nil` value' do
      let(:attributes) { {has_solicitor: nil} }
      it { expect(subject.has_solicitor?).to eq(false) }
    end

    context 'for a `no` value' do
      let(:attributes) { {has_solicitor: 'no'} }
      it { expect(subject.has_solicitor?).to eq(false) }
    end

    context 'for a `yes` value' do
      let(:attributes) { {has_solicitor: 'yes'} }
      it { expect(subject.has_solicitor?).to eq(true) }
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

  describe '#screener_answers_court' do
    before do
      allow(subject).to receive(:screener_answers).and_return(double)
    end

    it 'delegates the method to the `screener_answers`' do
      expect(subject.screener_answers).to receive(:court)
      subject.screener_answers_court
    end
  end
end
