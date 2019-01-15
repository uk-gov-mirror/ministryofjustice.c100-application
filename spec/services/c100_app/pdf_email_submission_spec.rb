require 'rails_helper'

RSpec.describe C100App::PdfEmailSubmission do
  let(:c100_application) {
    instance_double(
      C100Application,
      receipt_email: 'user@example.com',
      screener_answers_court: screener_answers_court,
      email_submission: email_submission,
    )
  }

  let(:pdf_content) { 'pdf content' }
  let(:screener_answers_court) { double('screener_answers_court', email: 'court@example.com') }
  let(:email_submission) { instance_double(EmailSubmission, sent_at: sent_at, user_copy_sent_at: user_copy_sent_at) }

  let(:sent_at) { '' }
  let(:user_copy_sent_at) { '' }

  let(:mailer) { spy('mailer') }

  subject { described_class.new(c100_application, pdf_content: pdf_content) }

  before do
    travel_to Time.at(0)
  end

  describe '#deliver!' do
    let(:application_details) {
      {
        c100_application: c100_application,
        c100_pdf: pdf_content,
      }
    }

    context 'submission_to_court' do
      before do
        allow(NotifySubmissionMailer).to receive(:with).with(application_details).and_return(mailer)
        allow(subject).to receive(:send_copy_to_user) # we test the user copy separately
      end

      it 'delivers the email to the court' do
        expect(
          mailer
        ).to receive(:application_to_court).with(to_address: 'court@example.com').and_return(mailer)

        expect(mailer).to receive(:deliver_now)

        expect(subject).to receive(:audit_data) # we test this separately

        subject.deliver!(:court)
      end

      it 'audits the email details' do
        expect(email_submission).to receive(:update).with(
          to_address: 'court@example.com',
          sent_at: Time.current,
        )

        subject.deliver!(:court)
      end
    end

    context 'send_copy_to_user' do
      before do
        allow(NotifySubmissionMailer).to receive(:with).with(application_details).and_return(mailer)
        allow(subject).to receive(:submission_to_court) # we test the court copy separately
      end

      it 'delivers the email to the applicant' do
        expect(
          mailer
        ).to receive(:application_to_user).with(to_address: 'user@example.com')

        expect(mailer).to receive(:deliver_now)

        expect(subject).to receive(:audit_data) # we test this separately

        subject.deliver!(:applicant)
      end

      it 'audits the email details' do
        expect(email_submission).to receive(:update).with(
          email_copy_to: 'user@example.com',
          user_copy_sent_at: Time.current,
        )

        subject.deliver!(:applicant)
      end
    end
  end
end
