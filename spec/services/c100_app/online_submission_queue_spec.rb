require 'rails_helper'

RSpec.describe C100App::OnlineSubmissionQueue do
  let(:c100_application) { C100Application.create(receipt_email: receipt_email) }
  let(:receipt_email) { nil }

  subject { described_class.new(c100_application) }

  describe '#process' do
    context 'when `email_submission` record already exists' do
      before do
        allow(c100_application).to receive(:email_submission).and_return(double)
      end

      it 'does not process the jobs' do
        expect {
          subject.process
        }.not_to have_enqueued_job
      end
    end

    context 'when `email_submission` record does not exist' do
      before do
        allow(c100_application).to receive(:email_submission).and_return(nil)
        allow(c100_application).to receive(:create_email_submission)
      end

      # mutant kill
      context 'uses `present?`' do
        let(:finder_double) { double }

        before do
          allow(c100_application).to receive(:email_submission).and_return(finder_double)
        end

        it {
          expect(finder_double).to receive(:present?)
          subject.process
        }
      end

      it 'creates the `email_submission` record' do
        expect(c100_application).to receive(:create_email_submission)
        subject.process
      end

      it 'enqueues the court delivery job' do
        expect {
          subject.process
        }.to have_enqueued_job(CourtDeliveryJob).with(c100_application).on_queue('submissions')
      end

      it 'does not enqueue the applicant delivery job' do
        expect {
          subject.process
        }.not_to have_enqueued_job(ApplicantDeliveryJob).with(c100_application).on_queue('submissions')
      end

      context 'when there is a receipt email address' do
        let(:receipt_email) { 'user@example.com' }

        it 'enqueues the applicant delivery job' do
          expect {
            subject.process
          }.to have_enqueued_job(ApplicantDeliveryJob).with(c100_application).on_queue('submissions')
        end
      end
    end
  end
end
