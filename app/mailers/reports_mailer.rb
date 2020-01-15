class ReportsMailer < NotifyMailer
  #
  # Internal reports to be sent by email. Triggered by `daily_tasks`.
  #
  def failed_emails_report(report_content, to_address:)
    set_template(:failed_emails_report)
    set_personalisation(report_content: report_content)

    mail to: to_address
  end
end
