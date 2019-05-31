module C100App
  class AddressLookupService
    class UnsuccessfulLookupError < StandardError; end

    ORDNANCE_SURVEY_URL = 'https://api.ordnancesurvey.co.uk/places/v1/addresses/postcode'.freeze

    attr_reader :postcode
    attr_reader :last_exception

    def initialize(postcode)
      @postcode = postcode
    end

    def result
      @result ||= MapAddressLookupResults.call(results)
    end

    def success?
      last_exception.nil?
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

    def perform_lookup
      uri = URI.parse(ORDNANCE_SURVEY_URL)
      uri.query = query_params.to_query
      response = Faraday.get(uri)

      raise UnsuccessfulLookupError unless response.success?

      parse_successful_response(
        response.body
      )
    rescue StandardError => ex
      Raven.capture_exception(ex)
      @last_exception = ex
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
