require 'rails_helper'

RSpec.describe C100App::OnlineSubmissionQueue do
  let(:c100_application) { C100Application.create(receipt_email: receipt_email) }
  let(:receipt_email) { nil }

  subject { described_class.new(c100_application) }

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe '#process' do
    let(:receipt_email) { '' }

    it 'enqueues the court delivery job' do
      expect {
        subject.process
      }.to have_enqueued_job.with(c100_application).on_queue('court_submissions')
    end

    it 'does not enqueue the applicant delivery job' do
      expect {
        subject.process
      }.not_to have_enqueued_job.with(c100_application).on_queue('applicant_receipts')
    end

    context 'when there is a receipt email address' do
      let(:receipt_email) { 'user@example.com' }

      it 'enqueues the applicant delivery job' do
        expect {
          subject.process
        }.to have_enqueued_job.with(c100_application).on_queue('applicant_receipts')
      end
    end
  end
end
