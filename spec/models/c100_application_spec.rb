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

  describe '.purge!' do
    let(:finder_double) { double.as_null_object }

    before do
      travel_to Time.now
    end

    it 'picks records equal to or older than the passed-in date' do
      expect(described_class).to receive(:where).with(
        'created_at <= :date', date: 28.days.ago
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

  describe '#court_from_screener_answers' do
    let(:screener_answers){ ScreenerAnswers.new(local_court: local_court) }

    before do
      subject.screener_answers = screener_answers
    end

    context 'when there is a local_court in screener_answers' do
      let(:local_court){ Court.new(name: 'my court') }
      let(:new_court){ Court.new(name: 'my court') }

      it 'returns a Court' do
        expect(subject.send(:court_from_screener_answers)).to be_a(Court)
      end

      describe 'the returned Court' do
        let(:returned_court){ subject.court_from_screener_answers }
        it 'has the right attributes' do
          expect(returned_court.name).to eq(new_court.name)
        end
      end
    end

    context 'when there is no local_court in screener_answers' do
      let(:local_court){ nil }
      it 'returns nil' do
        expect(subject.send(:court_from_screener_answers)).to eq(nil)
      end
    end
  end
end
