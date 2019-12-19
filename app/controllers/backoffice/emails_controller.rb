module Backoffice
  class EmailsController < Backoffice::ApplicationController
    include Auth0Secured

    def index
      @report = Reports::FailedEmailsReport.list
    end

    def lookup
      @reference_code = params[:reference_code]
      @email_address  = params[:email_address]

      @report = EmailSubmissionsAudit.find_records(@reference_code, @email_address)

      audit!(
        action: :email_lookup,
        details: { reference_code: @reference_code, email_address: @email_address, found: @report.size }
      )
    end

    def resend
      email = EmailSubmission.find(params[:email_id])
      type  = params[:type]

      email.resend!(type: type)
      audit_resend(email, resend_type: type)

      redirect_to backoffice_emails_path, flash: {
        alert: 'Email resend in progress. Please reload the page in a few seconds.'
      }
    end

    private

    def audit_resend(email, resend_type:)
      details = {
        reference_code: email.c100_application.reference_code
      }

      if resend_type == 'court'
        details.merge!(recipient: email.to_address)
      elsif resend_type == 'user'
        details.merge!(recipient: email.email_copy_to)
      end

      audit!(action: :resend_email, details: details)
    end
  end
end
