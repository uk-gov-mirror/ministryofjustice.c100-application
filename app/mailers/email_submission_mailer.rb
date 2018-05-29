class EmailSubmissionMailer < ApplicationMailer
  rescue_from Exception, with: :log_errors
  layout 'mailer'

  before_action do
    @service_name = I18n.translate!('service.name')
    @tech_email = ENV['TECH_EMAIL'] || 'insert-tech-email-here@example.com'
  end

  def submission_to_court(c100_application:, from:, to:, reply_to:, attachment:)
    attachments[c100_application.id + '.pdf'] = attachment_contents(attachment)

    mail(
      to: to,
      from: from,
      reply_to: reply_to
    )
  end

  def copy_to_user(c100_application:, from:, to:, reply_to:, attachment:)
    attachments[c100_application.id + '.pdf'] = attachment_contents(attachment)

    mail(
      to: to,
      from: from,
      reply_to: reply_to
    )
  end

  private

  def attachment_contents(attachment)
    File.read(attachment)
  end

  def c100_application
    @c100_application ||= C100Application.find(params[:c100_application_id])
  end

  def log_errors(exception)
    Rails.logger.info({caller: self.class.name, method: action_name, error: exception}.to_json)

    # Raven.extra_context(
    #   template_id: govuk_notify_template,
    #   personalisation: filtered_personalisation
    # )
    Raven.capture_exception(exception)
  end
end
