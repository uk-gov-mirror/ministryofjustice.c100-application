module Reports
  # :nocov:
  class FailedEmailsReport
    require 'csv'

    class_attribute :failures,
                    :report_type

    class << self
      # This class method is used in the back-office
      def list
        self.report_type = :backoffice
        self.failures = []

        EmailSubmission.where(
          created_at: 1.week.ago.beginning_of_day...Date.current.end_of_day
        ).joins(:c100_application).find_each(batch_size: 25) do |record|
          reference_code = record.c100_application.reference_code

          check_court_email(record, reference_code)

          # Only if the applicant chose to receive a confirmation, otherwise
          # these emails are not sent and there is no need to do any check.
          check_user_email(record, reference_code) if record.c100_application.receipt_email?
        end

        failures
      end

      # This class method is used in `lib/tasks/daily_tasks.rake`
      def run
        self.report_type = :daily_tasks
        self.failures = []

        EmailSubmission.where(
          created_at: Date.yesterday...Date.current
        ).joins(:c100_application).find_each(batch_size: 25) do |record|
          reference_code = record.c100_application.reference_code

          check_court_email(record, reference_code)

          # Only if the applicant chose to receive a confirmation, otherwise
          # these emails are not sent and there is no need to do any check.
          check_user_email(record, reference_code) if record.c100_application.receipt_email?
        end

        return if failures.empty?

        ReportsMailer.failed_emails_report(
          failures.map(&:to_csv).join
        ).deliver_now
      end

      def check_court_email(record, reference_code)
        reference = ['court', reference_code].join(';').freeze

        if record.sent_at.nil?
          failures << report_line(record, reference, 'error')
        elsif email_not_delivered?(reference)
          failures << report_line(record, reference, 'undelivered')
        end
      end

      def check_user_email(record, reference_code)
        reference = ['user', reference_code].join(';').freeze

        if record.user_copy_sent_at.nil?
          failures << report_line(record, reference, 'error')
        elsif email_not_delivered?(reference)
          failures << report_line(record, reference, 'undelivered')
        end
      end

      def email_not_delivered?(reference)
        EmailSubmissionsAudit.unscoped.order(completed_at: :desc).find_by(
          reference: reference,
          status: 'delivered',
        ).nil?
      end

      def report_line(record, reference, error_msg)
        if report_type == :backoffice
          Backoffice::FailedEmail.new(
            record: record,
            reference: reference,
            error: error_msg,
          )
        else
          [
            record.created_at,
            reference,
            error_msg,
          ]
        end
      end
    end
  end
  # :nocov:
end
