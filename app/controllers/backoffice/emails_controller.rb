module Backoffice
  class EmailsController < Backoffice::ApplicationController
    include Auth0Secured

    def index
      @report = Reports::FailedEmailsReport.list
    end

    def resend
      email = EmailSubmission.find(params[:email_id])
      email.resend!(type: params[:type])

      redirect_to backoffice_emails_path, flash: {
        alert: 'Email resend in progress. Please reload the page in a few seconds.'
      }
    end
  end
end
