class SubmissionMailer < ActionMailer::Base
  layout 'mailer'

  default from: 'from@example.com'
  default template_path: ->(mailer) { "mailers/#{mailer.class.name.underscore}" }

  before_action do
    @service_name = I18n.translate!('service.name')
    @tech_email = ENV['TECH_EMAIL'] || 'insert-tech-email-here@example.com'
  end

  protected

  # just for easier stubbing in specs
  def attachment_contents(attachment)
    File.read(attachment)
  end
end
