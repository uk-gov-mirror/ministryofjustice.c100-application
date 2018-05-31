require 'rails_helper'

RSpec.describe C100App::OnlineSubmission do
  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(c100_application) }

  describe '#process' do
    let(:pdf_presenter) { instance_double(Summary::PdfPresenter, generate: true, to_pdf: 'pdf content') }
    let(:email_submission) { instance_double(EmailSubmission) }

    before do
      allow(Summary::PdfPresenter).to receive(:new).with(c100_application).and_return(pdf_presenter)
    end

    it 'generates the PDF' do
      allow(subject).to receive(:send_emails) # do not care here about the emails

      expect(pdf_presenter).to receive(:generate)
      subject.process
      expect(subject.pdf_content).to eq('pdf content')
    end

    it 'sends the emails' do
      expect(File).to receive(:binwrite).with(kind_of(File), 'pdf content')

      expect(EmailSubmission).to receive(:create!).with(
        c100_application: c100_application
      ).and_return(email_submission)

      expect(email_submission).to receive(:send!).with(kind_of(File))

      subject.process
    end
  end
end
