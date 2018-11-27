require 'rails_helper'

RSpec.describe C100App::PdfEmailSubmission do
  let(:c100_application) {
    instance_double(
      C100Application,
      receipt_email: receipt_email,
      screener_answers_court: screener_answers_court,
      email_submission: email_submission,
    )
  }

  let(:pdf_file) { '/path/to/pdf' }
  let(:receipt_email) { 'user@example.com' }
  let(:screener_answers_court) { double('screener_answers_court', email: 'court@example.com') }
  let(:email_submission) { instance_double(EmailSubmission, message_id: message_id, user_copy_message_id: user_copy_message_id) }

  let(:mailer) { spy('mailer', deliver_now!: double('mailer_response', message_id: 'message-id')) }

  let(:message_id) { nil }
  let(:user_copy_message_id) { nil }

  subject { described_class.new(c100_application, pdf_file: pdf_file) }

  before do
    travel_to Time.at(0)
  end

  describe '#deliver!' do
    let(:application_details) {
      {
        c100_application: c100_application,
        c100_pdf: pdf_file,
      }
    }

    context 'submission_to_court' do
      before do
        allow(CourtMailer).to receive(:with).with(application_details).and_return(mailer)
        allow(subject).to receive(:send_copy_to_user) # we test the user copy separately
      end

      it 'delivers the email to the court' do
        expect(
          mailer
        ).to receive(:submission_to_court).with(to: 'court@example.com')

        expect(subject).to receive(:audit_data) # we test this separately

        subject.deliver!
      end

      it 'audits the email details' do
        expect(email_submission).to receive(:update).with(
          to_address: 'court@example.com',
          sent_at: Time.current,
          message_id: 'message-id'
        )

        subject.deliver!
      end

      context 'for a Notify email' do
        before do
          allow(subject).to receive(:use_notify?).and_return(true)

          allow(NotifySubmissionMailer).to receive(:with).with(application_details).and_return(mailer)
          allow(subject).to receive(:send_copy_to_user) # we test the user copy separately
        end

        let(:mailer) {
          spy('mailer', deliver_now!: double(
            'notify_mailer_response', govuk_notify_response: double(id: 'message-id'))
          )
        }

        it 'delivers the email to the court' do
          expect(
            mailer
          ).to receive(:application_to_court).with(to_address: 'court@example.com')

          expect(subject).to receive(:audit_data) # we test this separately

          subject.deliver!
        end

        it 'audits the email details' do
          expect(email_submission).to receive(:update).with(
            to_address: 'court@example.com',
            sent_at: Time.current,
            message_id: 'message-id'
          )

          subject.deliver!
        end
      end

      context 'there is already an audit of a previous submission' do
        let(:message_id) { '123-XYZ' }

        it 'does not deliver another email to the court' do
          expect(mailer).not_to receive(:submission_to_court)
          expect(subject).not_to receive(:audit_data)

          subject.deliver!
        end
      end
    end

    context 'send_copy_to_user' do
      before do
        allow(ReceiptMailer).to receive(:with).with(application_details).and_return(mailer)
        allow(subject).to receive(:submission_to_court) # we test the court copy separately
      end

      context 'when user chose to receive a copy' do
        let(:receipt_email) { 'user@example.com' }

        it 'delivers the email to the user' do
          expect(
            mailer
          ).to receive(:copy_to_user).with(
            to: 'user@example.com', reply_to: 'court@example.com'
          )

          expect(subject).to receive(:audit_data) # we test this separately

          subject.deliver!
        end

        it 'audits the email details' do
          expect(email_submission).to receive(:update).with(
            email_copy_to: 'user@example.com',
            user_copy_sent_at: Time.current,
            user_copy_message_id: 'message-id',
          )

          subject.deliver!
        end

        context 'for a Notify email' do
          before do
            allow(subject).to receive(:use_notify?).and_return(true)

            allow(NotifySubmissionMailer).to receive(:with).with(application_details).and_return(mailer)
            allow(subject).to receive(:submission_to_court) # we test the court copy separately
          end

          let(:mailer) {
            spy('mailer', deliver_now!: double(
              'notify_mailer_response', govuk_notify_response: double(id: 'message-id'))
            )
          }

          it 'delivers the email to the user' do
            expect(
              mailer
            ).to receive(:application_to_user).with(to_address: 'user@example.com')

            expect(subject).to receive(:audit_data) # we test this separately

            subject.deliver!
          end

          it 'audits the email details' do
            expect(email_submission).to receive(:update).with(
              email_copy_to: 'user@example.com',
              user_copy_sent_at: Time.current,
              user_copy_message_id: 'message-id',
            )

            subject.deliver!
          end
        end

        context 'there is already an audit of a previous submission' do
          let(:user_copy_message_id) { '123-XYZ' }

          it 'does not deliver another email to the user' do
            expect(mailer).not_to receive(:copy_to_user)
            expect(subject).not_to receive(:audit_data)

            subject.deliver!
          end
        end
      end

      context 'when user chose not to receive a copy' do
        let(:receipt_email) { nil }

        it 'does not send any copy to the user' do
          expect(mailer).not_to receive(:copy_to_user)
          subject.deliver!
        end
      end

      context 'when `receipt_email` is empty (mutant kill)' do
        let(:receipt_email) { '' }

        it 'does not send any copy to the user' do
          expect(mailer).not_to receive(:copy_to_user)
          subject.deliver!
        end
      end
    end
  end

  describe '`email_submission` audit table' do
    context 'when table does not exist' do
      let(:email_submission) { nil }

      it 'creates a new `email_submission` if none exists' do
        expect(c100_application).to receive(:create_email_submission)
        subject.email_submission
      end
    end

    context 'when table already exists' do
      let(:email_submission) { double }

      it 'creates a new `email_submission` if none exists' do
        expect(c100_application).not_to receive(:create_email_submission)
        subject.email_submission
      end
    end
  end

  # TODO: temporary feature-flag, mutant wants to test this too
  describe '#use_notify?' do
    context 'environment' do
      before do
        allow(Rails.env).to receive(:development?).and_return(development)
      end

      context 'development' do
        let(:development) { true }
        it { expect(subject.use_notify?).to eq(true) }
      end

      context 'not development' do
        let(:development) { false }
        it { expect(subject.use_notify?).to eq(false) }
      end
    end

    context 'DEV_TOOLS_ENABLED' do
      before do
        allow(ENV).to receive(:key?).with('DEV_TOOLS_ENABLED').and_return(dev_tools)
      end

      context 'dev_tools enabled' do
        let(:dev_tools) { true }
        it { expect(subject.use_notify?).to eq(true) }
      end

      context 'dev_tools not enabled' do
        let(:dev_tools) { false }
        it { expect(subject.use_notify?).to eq(false) }
      end
    end
  end
end
