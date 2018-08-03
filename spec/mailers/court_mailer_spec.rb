require 'rails_helper'

RSpec.describe CourtMailer, type: :mailer do
  let(:c100_application) {
    C100Application.new(
      id: '449362af-0bc3-4953-82a7-1363d479b876',
      created_at: Time.at(0),
      urgent_hearing: urgent_hearing,
      address_confidentiality: address_confidentiality,
    )
  }

  let(:urgent_hearing) { nil }
  let(:address_confidentiality) { nil }
  let(:pdf_file) { '/my/test/file' }

  let(:recipient_args) {
    {
      to: 'testto@example.com',
    }
  }

  describe '#submission_to_court' do
    before do
      allow(File).to receive(:read).with(pdf_file).and_return('file content')
    end

    context 'given all required arguments' do
      describe 'the generated mail' do
        let(:mail) do
          described_class.with(
            c100_application: c100_application, c100_pdf: pdf_file
          ).submission_to_court(recipient_args)
        end

        it_behaves_like 'a Submission mailer'

        it 'does not have a reply_to address' do
          expect(mail.reply_to).to be_nil
        end

        describe 'subject' do
          context 'for an urgent hearing application' do
            let(:urgent_hearing) { GenericYesNo::YES }

            it 'has the right subject' do
              expect(
                mail.subject
              ).to eq('URGENT - C100 new application - child arrangements')
            end
          end

          context 'for a non-urgent application' do
            let(:urgent_hearing) { GenericYesNo::NO }

            it 'has the right subject' do
              expect(
                mail.subject
              ).to eq('C100 new application - child arrangements')
            end
          end
        end

        describe 'C8 application warning in email body' do
          context 'when C8 was triggered' do
            let(:address_confidentiality) { GenericYesNo::YES }
            it { expect(mail.body.encoded).to match('C8 form is included') }
          end

          context 'when C8 was not triggered' do
            let(:address_confidentiality) { GenericYesNo::NO }
            it { expect(mail.body.encoded).not_to match('C8 form is included') }
          end
        end

        context 'assigns the first applicant full name' do
          before do
            allow(
              c100_application
            ).to receive(:applicants).and_return(
              [double('Applicant', full_name: 'John Doe')]
            )
          end

          it { expect(mail.body.encoded).to match('John Doe') }
        end
      end
    end
  end
end
