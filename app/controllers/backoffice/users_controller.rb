module Backoffice
  class UsersController < Backoffice::ApplicationController
    before_action :authenticate, only: [:exists]

    # This endpoint is used by an Auth0 rule to ensure the user signin-in to the
    # backoffice have been granted access.
    # To minimise bad actors hitting this endpoint, we use a bearer token.
    # Refer to the rule for details: `config/auth0/rules/check_user_exists.js`
    #
    def exists
      user = BackofficeUser.active.find_by(email: params[:id])
      return head(404) if user.nil?

      user.logins_count += 1
      user.last_login_at = user.current_login_at
      user.current_login_at = Time.now.utc
      user.save

      head(200)
    end

    private

    def authenticate
      authenticate_or_request_with_http_token do |token|
        ActiveSupport::SecurityUtils.secure_compare(token, ENV['AUTH0_RULES_BEARER_TOKEN'])
      end
    end
  end
end
