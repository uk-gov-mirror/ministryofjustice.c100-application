class StatusController < ApplicationController
  respond_to :json

  def index
    check = C100App::Status.new
    status_code = check.success? ? :ok : :service_unavailable

    respond_with(check.result, status: status_code)
  end
end
