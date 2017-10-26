class StatusController < ApplicationController
  respond_to :json

  def index
    respond_with(C100App::Status.check)
  end
end
