require 'json'
require 'open-uri'

class CourtfinderAPI
  attr_accessor :logger
  API_URL = "https://courttribunalfinder.service.gov.uk/%s.json?aol=%s&postcode=%s"

  def initialize(params={})
    self.logger = params[:logger] || Rails.logger
  end
  
  def court_for(area_of_law, postcode)
    begin
      JSON.parse(search(area_of_law, postcode))
    rescue Exception => e
      handle_error(e)
    end
  end

  def search(area_of_law, postcode)
    safe_postcode = postcode.gsub(/[^a-z0-9]/i, '')
    url = construct_url('search/results', area_of_law, safe_postcode)
    open(url).read
  end

  private

  def construct_url(endpoint, *args)
    sprintf(API_URL, endpoint, *args)
  end

  # TODO: what's our plan for exception handling?
  # For now, just log it and re-raise - the caller should know what to do
  # better than we can (Dev principle!)
  def handle_error(e)
    log_error("Exception hitting Courtfinder:", e)
    raise
  end

  def log_error(msg, exception)
    logger.add(Logger::ERROR) do
      [
        [msg, e.message] + e.backtrace
      ].join("\n")
    end
  end
end