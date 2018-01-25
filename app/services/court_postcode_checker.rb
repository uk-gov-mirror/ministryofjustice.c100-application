require 'courtfinder_api'

class CourtPostcodeChecker
  AREA_OF_LAW = "Children".freeze
  COURT_SLUGS_USING_THIS_APP = [
    "central-family-court",
    "east-london-family-court"
  ].freeze

  # Separate multiple postcodes/postcode areas by "\n"
  # Will return an array of courts to which the application
  # could be sent, based on the postcodes given.
  # If the courts serving the postcodes given are not
  # taking part in our service, they will not be returned
  def courts_for(postcodes)
    postcodes.split("\n").reject(&:blank?).map do |postcode|
      court_for(postcode)
    end.compact
  end

  def court_for(postcode)
    possible_courts = CourtfinderAPI.new.court_for(AREA_OF_LAW, postcode)
    choose_from(possible_courts)
  end

  private

  def choose_from(possible_courts)
    possible_courts.find do |court|
      COURT_SLUGS_USING_THIS_APP.include?(court['slug'] || court[:slug])
    end
  end
end
