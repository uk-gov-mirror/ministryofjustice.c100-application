require "rails_helper"

RSpec.describe ReceiptMailer, type: :mailer do
  let(:c100_application) {
    C100Application.new(
      id: '449362af-0bc3-4953-82a7-1363d479b876',
      created_at: Time.at(0)
    )
  }

  let(:pdf_file) { '/my/test/file' }

  let(:recipient_args) {
    {
      to: 'testto@example.com',
      reply_to: 'replyto@example.com',
    }
  }

  describe '#copy_to_user' do
    before do
      allow(File).to receive(:read).with(pdf_file).and_return('file content')
    end

    context 'given all required arguments' do
      describe 'the generated mail' do
        let(:mail) do
          described_class.with(
            c100_application: c100_application, c100_pdf: pdf_file
          ).copy_to_user(recipient_args)
        end

        it_behaves_like 'a Submission mailer'

        it 'has the right subject' do
          expect(mail.subject).to eq('C100 New application - Child arrangements')
        end
      end
    end
  end
end
