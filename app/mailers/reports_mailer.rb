class ReportsMailer < NotifyMailer
  #
  # Internal reports to be sent by email. Triggered by `daily_tasks`.
  #
  def failed_emails_report(report_content)
    set_template(:failed_emails_report)
    set_personalisation(report_content: report_content)

    # Unset the env variable to stop the emails (for example
    # on staging we don't want these emails, only on production)
    recipient = ENV['FAILED_EMAILS_REPORT_RECIPIENT']
    return if recipient.nil?

    mail to: recipient
  end
end
