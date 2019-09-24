module Backoffice
  class DashboardController < Backoffice::ApplicationController
    include Auth0Secured

    def index
      @report = CompletedApplicationsAudit.unscoped.order(completed_at: :desc).limit(50)
    end
  end
end
