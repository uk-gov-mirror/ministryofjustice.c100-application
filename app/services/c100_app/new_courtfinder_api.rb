require 'net/http'
require 'json'
require 'uri'

module C100App
  class NewCourtfinderApi
    API_BASE_URL = ENV.fetch('COURT_API_BASE_URL').freeze
    SEARCH_PATH = '/fact/search/courts/v1/postcode'.freeze
    COURT_PATH = '/fact/courts/slug/%<slug>s/v1'.freeze

    HTTP_HEADERS = {
      'Accept' => 'application/json',
      'User-Agent' => 'child-arrangements-service',
    }.freeze

    HTTP_OPTIONS = {
      open_timeout: 10,
      read_timeout: 20,
      use_ssl: true,
    }.freeze

    def initialize(token: NewCourtfinderApiToken.new)
      @token = token
    end

    def court_for(area_of_law, postcode)
      safe_postcode = postcode.upcase.gsub(/[^A-Z0-9]/, '')
      safe_postcode = "#{safe_postcode[0...-3]} #{safe_postcode[-3..]}" # All postcodes must have a space for new api

      query = URI.encode_www_form(
        postcode: safe_postcode,
        serviceArea: area_of_law,
        action: 'NEAREST'
      )

      path = "#{SEARCH_PATH}?#{query}"

      get_request(path)
    end

    def court_lookup(slug)
      path = format(COURT_PATH, slug:)

      get_request(path)
    end

    def is_ok?
      court_for('Childcare arrangements if you separate from your partner', 'SW1A 1AA').present?
    rescue StandardError
      false
    end

    private

    def get_request(path)
      request = Net::HTTP::Get.new(path, HTTP_HEADERS)
      request['Authorization'] = "Bearer #{@token.token}"

      uri = URI.parse(API_BASE_URL)

      Net::HTTP.start(uri.host, uri.port, :ENV, **HTTP_OPTIONS) do |http|
        response = http.request(request)

        unless response.is_a?(Net::HTTPSuccess)
          Sentry.capture_message("Court Finder request failed: HTTP #{response.code}, path: #{path.split('?').last}")
          raise "Court Finder request failed: HTTP #{response.code}"
        end

        JSON.parse(response.body)
      end
    rescue StandardError => ex
      log_and_raise(ex)
    end

    def log_and_raise(exception)
      Sentry.capture_exception(exception)
      raise
    end
  end
end
