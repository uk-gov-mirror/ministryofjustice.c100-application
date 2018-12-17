require "rails_helper"

RSpec.describe ReceiptMailer, type: :mailer do
  let(:c100_application) {
    C100Application.new(
      id: '449362af-0bc3-4953-82a7-1363d479b876',
      created_at: Time.at(0)
    )
  }

  let(:pdf_content) { instance_double(StringIO, 'pdf content') }

  let(:recipient_args) {
    {
      to: 'testto@example.com',
      reply_to: 'replyto@example.com',
    }
  }

  describe '#copy_to_user' do
    before do
      allow(pdf_content).to receive(:read).and_return('file content')

      allow(
        c100_application
      ).to receive(:screener_answers_court).and_return(
        double('Court', name: 'Court XYZ', slug: 'court-xyz', present?: true).as_null_object
      )
    end

    context 'given all required arguments' do
      describe 'the generated mail' do
        let(:mail) do
          described_class.with(
            c100_application: c100_application, c100_pdf: pdf_content
          ).copy_to_user(recipient_args)
        end

        it_behaves_like 'a Submission mailer'

        it 'has the right subject' do
          expect(mail.subject).to eq('C100 new application - child arrangements')
        end

        it 'has the given reply_to address' do
          expect(mail.reply_to).to eq(['replyto@example.com'])
        end

        context 'assigns the court data' do
          it { expect(mail.body.encoded).to match('Court XYZ') }
          it { expect(mail.body.encoded).to match('https://courttribunalfinder.service.gov.uk/courts/court-xyz') }
        end
      end
    end
  end
end
