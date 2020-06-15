require 'rails_helper'

RSpec.describe PaymentsMopUpJob, type: :job do
  describe '.run' do
    let(:c100_application) { C100Application.new(id: '449362af-0bc3-4953-82a7-1363d479b876') }

    let(:finder_double) { double.as_null_object }
    let(:time_ago) { 15.minutes.ago }

    before do
      allow(C100Application).to receive(:payment_in_progress).and_return(finder_double)
    end

    it 'finds any pending payment intents' do
      expect(finder_double).to receive(:joins).with(:payment_intent).and_return(finder_double)
      expect(finder_double).to receive(:where).with("payment_intents.state ->> 'finished' = 'false'").and_return(finder_double)
      expect(finder_double).to receive(:where).with("payment_intents.created_at <= :date", date: time_ago).and_return(finder_double)

      expect(finder_double).to receive(:each)
      expect(described_class).not_to receive(:perform_later)

      described_class.run(time_ago)
    end

    it 'enqueues a status refresh for each application found' do
      expect(finder_double).to receive(:each).and_yield(c100_application)
      expect(described_class).to receive(:perform_later).with(c100_application)

      # Mutant kill
      expect(Rails.logger).to receive(:info).with(
        'Enqueuing payment status refresh for application 449362af-0bc3-4953-82a7-1363d479b876'
      )

      described_class.run(time_ago)
    end
  end

  describe '#perform' do
    let(:c100_application) { instance_double(C100Application, online_submission?: online_submission, payment_intent: payment_intent) }
    let(:payment_intent) { instance_double(PaymentIntent) }
    let(:payment_result) { double(success?: success) }

    before do
      allow(
        C100App::OnlinePayments
      ).to receive(:retrieve_payment).with(payment_intent).and_return(payment_result)
    end

    context 'for a success payment' do
      let(:success) { true }

      context 'for an online submission' do
        let(:online_submission) { true }
        let(:queue) { double.as_null_object }

        it 'marks the application as completed and process the application online submission' do
          expect(c100_application).to receive(:mark_as_completed!)
          expect(C100App::OnlineSubmissionQueue).to receive(:new).with(c100_application).and_return(queue)
          expect(queue).to receive(:process)

          described_class.perform_now(c100_application)
        end
      end

      context 'for an offline submission' do
        let(:online_submission) { false }

        it 'marks the application as completed' do
          expect(c100_application).to receive(:mark_as_completed!)
          expect(C100App::OnlineSubmissionQueue).not_to receive(:new)

          described_class.perform_now(c100_application)
        end
      end
    end

    context 'for a failed payment' do
      let(:success) { false }
      let(:online_submission) { true }

      it 'does nothing' do
        expect(c100_application).not_to receive(:mark_as_completed!)
        expect(C100App::OnlineSubmissionQueue).not_to receive(:new)

        described_class.perform_now(c100_application)
      end
    end
  end
end
