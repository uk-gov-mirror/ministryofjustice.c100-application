class SubmissionMailer < ActionMailer::Base
  layout 'mailer'

  default from: -> { ENV['SUBMISSION_EMAIL_FROM'] || 'from@example.com' }
  default template_path: ->(mailer) { "mailers/#{mailer.class.name.underscore}" }

  before_action do
    @service_name = I18n.translate!('service.name')
    @c100_application = params[:c100_application]
    @reference_code = @c100_application.reference_code
    @c100_pdf = params[:c100_pdf]
  end

  protected

  def attach_c100_pdf!
    attachments[pdf_attachment_filename] = File.read(@c100_pdf)
  end

  private

  def pdf_attachment_filename
    @c100_application.reference_code + '.pdf'
  end
end
