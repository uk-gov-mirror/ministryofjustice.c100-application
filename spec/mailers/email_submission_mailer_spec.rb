require "rails_helper"

RSpec.describe EmailSubmissionMailer, type: :mailer do

  let(:c100_application){ C100Application.create! }

  describe '#submission_to_court' do
    let(:file){ '/my/test/file' }
    before do
      allow_any_instance_of(described_class).to receive(:attachment_contents)
                                            .with(file)
                                            .and_return('file content')
    end

    context 'given all required arguments' do
      let(:args){
        {
          c100_application: c100_application,
          from: 'testfrom@example.com',
          to: 'testto@example.com',
          reply_to: 'replyto@example.com',
          attachment: file
        }
      }

      describe 'the generated mail' do
        let(:mail) do
          described_class.submission_to_court(args)
        end

        it 'is a MessageDelivery object' do
          expect(mail.class.name).to eq(
            "ActionMailer::MessageDelivery"
          )
        end

        describe 'when delivered' do
          it 'sends the mail' do
            expect{ mail.deliver_now }.to \
                    change { ActionMailer::Base.deliveries.size }.by(1)
          end
        end

        it 'has the right subject' do
          expect(mail.subject).to eq(
            I18n.t( :subject,
                    scope: [:email_submission_mailer, :submission_to_court])
          )
        end

        it 'has the given from address' do
          expect(mail.from).to eq(['testfrom@example.com'])
        end

        it 'has the given to address' do
          expect(mail.to).to eq(['testto@example.com'])
        end

        it 'has the given reply_to address' do
          expect(mail.reply_to).to eq(['replyto@example.com'])
        end

        it 'has one attachment' do
          expect(mail.attachments.size).to eq(1)
        end

        describe 'the attachment' do
          let(:attachment){ mail.attachments.last }

          it 'is a pdf' do
            expect(attachment.content_type).to start_with('application/pdf')
          end

          it 'is the right file' do
            expect(attachment.filename).to eq(c100_application.id + '.pdf')
          end
        end
      end
    end
  end
end
