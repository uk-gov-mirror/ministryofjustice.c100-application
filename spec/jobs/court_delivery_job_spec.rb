require 'rails_helper'

RSpec.describe CourtDeliveryJob, type: :job do
  let(:c100_application) { instance_double(C100Application, id: '123-456', receipt_email: receipt_email) }
  let(:receipt_email) { nil }

  let(:queue) { double.as_null_object }

  describe '#perform' do
    it 'calls the `CourtOnlineSubmission` service to process the submission' do
      expect(C100App::CourtOnlineSubmission).to receive(:new).with(
        c100_application
      ).and_return(queue)

      expect(queue).to receive(:process)
      expect(GC).to receive(:start)

      CourtDeliveryJob.perform_now(c100_application)
    end

    context 'an exception occurs' do
      before do
        allow_any_instance_of(C100App::CourtOnlineSubmission).to receive(:process).and_raise(NoMethodError)
      end

      it 'captures the error' do
        expect(Raven).to receive(:extra_context).with({ c100_application_id: '123-456' })
        expect(Raven).to receive(:capture_exception).with(NoMethodError)

        expect(GC).to receive(:start)

        CourtDeliveryJob.perform_now(c100_application)
      end

      context 'there is a receipt email' do
        let(:receipt_email) { 'receipt@example.com' }
        let(:mailer_double) { double.as_null_object }

        before do
          allow(
            NotifyMailer
          ).to receive(:submission_error).with(
            c100_application
          ).and_return(mailer_double)
        end

        it 'sends an email to the user do' do
          CourtDeliveryJob.perform_now(c100_application)
          expect(mailer_double).to have_received(:deliver_later)
        end
      end
    end
  end
end
