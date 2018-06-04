require 'rails_helper'

RSpec.shared_examples 'a Submission mailer' do
  let(:env_submission_email_from) { nil }
  let(:env_ses_config_set) { nil }

  before do
    allow(ENV).to receive(:[]).with('SUBMISSION_EMAIL_FROM').and_return(env_submission_email_from)
    allow(ENV).to receive(:[]).with('SES_CONFIG_SET').and_return(env_ses_config_set)
  end

  it 'is a MessageDelivery object' do
    expect(mail).to be_kind_of(ActionMailer::MessageDelivery)
  end

  describe 'when delivered' do
    it 'sends the mail' do
      expect{ mail.deliver_now }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end
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
      expect(attachment.filename).to eq('1970/01/449362AF.pdf')
    end
  end

  describe '`from` address' do
    context 'no ENV variable set' do
      it 'uses the default `from` address' do
        expect(mail.from).to eq(['from@example.com'])
      end
    end

    context 'ENV variable is set' do
      let(:env_submission_email_from) { 'env@example.com' }

      it 'uses the ENV variable' do
        expect(mail.from).to eq(['env@example.com'])
      end
    end
  end

  describe '`X-SES-CONFIGURATION-SET` header' do
    context 'no ENV variable set' do
      it 'uses the default configuration set' do
        expect(mail.header['X-SES-CONFIGURATION-SET'].to_s).to eq('ses-c100-config-set')
      end
    end

    context 'ENV variable is set' do
      let(:env_ses_config_set) { 'ses-test-set' }

      it 'uses the ENV variable' do
        expect(mail.header['X-SES-CONFIGURATION-SET'].to_s).to eq('ses-test-set')
      end
    end
  end
end
