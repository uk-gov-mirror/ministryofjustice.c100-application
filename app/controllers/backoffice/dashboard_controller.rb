module Backoffice
  class DashboardController < Backoffice::ApplicationController
    include Auth0Secured

    def index; end
  end
end
