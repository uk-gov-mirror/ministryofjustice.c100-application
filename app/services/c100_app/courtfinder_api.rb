require 'json'
require 'open-uri'

module C100App
  class CourtfinderAPI
    API_ROOT ||= "https://courttribunalfinder.service.gov.uk/".freeze
    API_URL  ||= "#{API_ROOT}%<endpoint>s.json?aol=%<aol>s&postcode=%<pcd>s".freeze

    SLUGS_CACHE_OPTIONS ||= {
      namespace: 'courtfinder',
      expires_in: 72.hours,
      compress: false,
      skip_nil: true
    }.freeze

    def court_for(area_of_law, postcode)
      JSON.parse(search(area_of_law, postcode))
    rescue StandardError => ex
      log_and_raise(ex)
    end

    def search(area_of_law, postcode)
      safe_postcode = postcode.gsub(/[^a-z0-9]/i, '')
      url = construct_url('search/results', area_of_law, safe_postcode)
      open(url).read
    end

    def court_url(slug, format: nil)
      slug_with_extension = [slug, format].compact.join('.')
      URI.join(API_ROOT, '/courts/', slug_with_extension).to_s
    end

    def court_lookup(slug)
      cache.fetch(slug, SLUGS_CACHE_OPTIONS) do
        JSON.parse(open(court_url(slug, format: :json)).read)
      end
    end

    def is_ok?
      status.eql? '200'
    end

    # Very basic cache to save a few API requests.
    # It uses `MemoryStore` on dev/test by default, and `RedisCacheStore` on prod.
    # Refer to `config/initializers/cache_store.rb` for more details.
    #
    def cache
      Rails.cache
    end

    private

    def status
      request = Net::HTTP::Get.new('/healthcheck.json')
      http_object.request(request).code
    end

    def http_object
      uri = api_root_uri
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (http.port == 443)
      http
    end

    def api_root_uri
      URI.parse(API_ROOT)
    end

    def construct_url(endpoint, area_of_law, postcode)
      format(API_URL, endpoint: endpoint, aol: area_of_law, pcd: postcode)
    end

    def log_and_raise(exception)
      Raven.capture_exception(exception)
      raise
    end
  end
end
