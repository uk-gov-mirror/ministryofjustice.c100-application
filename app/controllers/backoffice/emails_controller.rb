module Backoffice
  class EmailsController < Backoffice::ApplicationController
    include Auth0Secured

    def index; end
  end
end
