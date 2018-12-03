class CallbacksController < ActionController::Base
  # Note: this controller does not inherit from `ApplicationController` as
  # we don't require here the same level of security and error handling.
  before_action :authenticate

  respond_to :json

  rescue_from StandardError do |exception|
    Raven.capture_exception(exception)
    head 500
  end

  def notify
    C100App::NotifyCallback.new(payload).process!
    head 200
  end

  private

  # For now we only have a service (Notify) using callbacks, so we don't
  # need to parametrise this method, as we only need one ENV variable.
  #
  def authenticate
    authenticate_or_request_with_http_token do |token|
      ActiveSupport::SecurityUtils.secure_compare(token, ENV['GOVUK_NOTIFY_BEARER_TOKEN'])
    end
  end

  def payload
    params.permit(callback: {}).fetch(:callback)
  end
end
