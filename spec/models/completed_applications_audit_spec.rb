require 'rails_helper'

RSpec.describe CompletedApplicationsAudit, type: :model do
  let(:c100_application) {
    instance_double(
      C100Application,
      created_at: Time.at(0),
      updated_at: Time.at(100),
      user_id: user_id,
      submission_type: 'whatever',
      screener_answers_court: screener_answers_court,
    )
  }

  let(:user_id) { nil }
  let(:screener_answers_court) { double(name: 'Test Court') }

  describe 'db table name' do
    it { expect(described_class.table_name).to eq('completed_applications_audit') }
  end

  describe '.log!' do
    it 'creates a record with the expected information' do
      expect(
        described_class
      ).to receive(:create).with(
        started_at: Time.at(0),
        completed_at: Time.at(100),
        saved: false,
        submission_type: 'whatever',
        court: 'Test Court',
      )

      described_class.log!(c100_application)
    end

    context 'for a saved application' do
      let(:user_id) { 123 }

      it 'creates a record with the expected information' do
        expect(
          described_class
        ).to receive(:create).with(
          hash_including(saved: true)
        )

        described_class.log!(c100_application)
      end
    end

    context 'for an application without screener_answers court data' do
      # Note: this scenario should only be theoretical, but mutant wants to test it
      let(:screener_answers_court) { nil }

      it 'creates a record with the expected information' do
        expect(
          described_class
        ).to receive(:create).with(
          hash_including(court: nil)
        )

        described_class.log!(c100_application)
      end
    end
  end
end
