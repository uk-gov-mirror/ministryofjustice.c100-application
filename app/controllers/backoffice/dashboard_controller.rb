module Backoffice
  class DashboardController < Backoffice::ApplicationController
    include Auth0Secured

    def index
      @form = Backoffice::LookupForm.new

      @report = completed_report
      @payments_report = payments_report
    end

    def lookup
      @form = Backoffice::LookupForm.new(form_params)
      @report = []

      render :lookup && return if @form.invalid?

      @report = CompletedApplicationsAudit.where(reference_code: @form.reference_code)

      audit!(
        action: :application_lookup,
        details: { reference_code: @form.reference_code, found: @report.size }
      )
    end

    private

    def form_params
      params.require(:backoffice_lookup_form).permit(:reference_code)
    end

    def default_limit
      50
    end

    def completed_report
      CompletedApplicationsAudit.unscoped.order(completed_at: :desc).limit(default_limit)
    end

    def payments_report
      PaymentIntent.order(updated_at: :desc).limit(default_limit)
    end
  end
end
