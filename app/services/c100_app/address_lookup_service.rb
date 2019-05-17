module C100App
  class AddressLookupService
    ORDNANCE_SURVEY_URL = 'https://api.ordnancesurvey.co.uk/places/v1/addresses/postcode'.freeze

    attr_reader :postcode

    def initialize(postcode)
      @postcode = postcode
    end

    def result
      @result ||= MapAddressLookupResults.call(results)
    end

    def success?
      !failure?
    end

    def errors
      @errors ||= AddressLookupErrors.new
    end

    private

    def query_params
      {
        key: ENV.fetch('ORDNANCE_SURVEY_API_KEY'),
        postcode: postcode
      }
    end

    def results
      @results ||= perform_lookup
    end

    def failure?
      errors.any?
    end

    # TODO: report to Sentry errors for monitoring purposes
    def perform_lookup
      uri = URI.parse(ORDNANCE_SURVEY_URL)
      uri.query = query_params.to_query
      response = Faraday.get(uri)

      if response.success?
        parse_successful_response(response.body)
      else
        errors.add(:lookup, :unsuccessful)
        []
      end
    rescue Faraday::ConnectionFailed
      errors.add(:lookup, :service_unavailable)
      []
    rescue JSON::ParserError, KeyError
      errors.add(:lookup, :parser_error)
      []
    end

    def parse_successful_response(response)
      parsed_body = JSON.parse(response)

      if parsed_body.fetch('header').fetch('totalresults').positive?
        parsed_body.fetch('results')
      else
        []
      end
    end
  end
end
