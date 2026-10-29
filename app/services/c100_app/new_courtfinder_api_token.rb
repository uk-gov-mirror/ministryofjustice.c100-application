require 'net/http'
require 'json'
require 'uri'

module C100App
  class NewCourtfinderApiToken
    include CourtfinderTokenable

    TOKEN_URL = ENV.fetch('COURT_API_TOKEN_URL').freeze

    HTTP_OPTIONS = {
      open_timeout: 10,
      read_timeout: 20,
      use_ssl: true,
    }.freeze

    def token
      credentials = courtfinder_api_credentials
      return credentials[:access_token] if credentials.present?

      fetch_token
    rescue StandardError => ex
      log_and_raise(ex)
    end

    private

    def fetch_token
      uri = URI.parse(TOKEN_URL)

      request = Net::HTTP::Post.new(uri)
      request['Accept'] = 'application/json'
      request['User-Agent'] = 'child-arrangements-service'

      request.set_form_data(
        grant_type: 'client_credentials',
        client_id: ENV.fetch('COURT_API_CLIENT_ID'),
        client_secret: ENV.fetch('COURT_API_CLIENT_SECRET'),
        scope: ENV.fetch('COURT_API_SCOPE')
      )

      response = Net::HTTP.start(
        uri.host,
        uri.port,
        :ENV,
        HTTP_OPTIONS
      ) do |http|
        http.request(request)
      end

      unless response.is_a?(Net::HTTPSuccess)
        Sentry.capture_message("Court Finder token request failed: HTTP #{response.code}")
      end

      body = JSON.parse(response.body)
      access_token = body.fetch('access_token')
      expires_in = Integer(body.fetch('expires_in'))

      update_courtfinder_token(access_token, expires_in)

      access_token
    end

    def log_and_raise(exception)
      Sentry.capture_exception(exception)
      raise
    end
  end
end