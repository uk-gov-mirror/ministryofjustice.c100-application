module Reports
  # :nocov:
  class FailedEmailsReport
    require 'csv'

    def self.run
      failures = []

      EmailSubmission.where(
        created_at: Date.yesterday...Date.current
      ).joins(:c100_application).find_each(batch_size: 25) do |record|
        if record.sent_at.nil?
          failures << report_line(record, 'court email')
        end

        # Only if the applicant chose to receive a confirmation, otherwise
        # this attribute will be genuinely `nil` on purpose.
        if record.user_copy_sent_at.nil? && record.c100_application.receipt_email?
          failures << report_line(record, 'applicant email')
        end
      end

      return if failures.empty?

      ReportsMailer.failed_emails_report(
        failures.map(&:to_csv).join
      ).deliver_now
    end

    def self.report_line(record, email_type)
      [
        record.created_at,
        record.c100_application.reference_code,
        email_type,
      ]
    end
  end
  # :nocov:
end
