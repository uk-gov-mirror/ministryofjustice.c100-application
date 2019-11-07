require 'c100_app/courtfinder_api'

module C100App
  class CourtPostcodeChecker
    AREA_OF_LAW = "Children".freeze
    COURT_SLUGS_USING_THIS_APP = %w[
      reading-county-court-and-family-court
      guildford-county-court-and-family-court
      milton-keynes-county-court-and-family-court
      watford-county-court-and-family-court
      slough-county-court-and-family-court
      kingston-upon-hull-combined-court-centre
      oxford-combined-court-centre
      bristol-civil-and-family-justice-centre
      preston-crown-court-and-family-court-sessions-house
      newcastle-upon-tyne-combined-court-centre
      nottingham-county-court-and-family-court
      leeds-combined-court-centre
      west-london-family-court
      cardiff-civil-and-family-justice-centre
      leicester-county-court-and-family-court
      east-london-family-court
      newport-south-wales-county-court-and-family-court
      southampton-combined-court-centre
      swansea-civil-justice-centre
      exeter-combined-court-centre
      medway-county-court-and-family-court
      liverpool-civil-and-family-court
      plymouth-combined-court
      peterborough-combined-court-centre
      barnstaple-magistrates-county-and-family-court
      portsmouth-combined-court-centre
      isle-of-wight-combined-court
      sheffield-combined-court-centre
      doncaster-magistrates-court-and-family-court
      barnsley-law-courts
      lincoln-county-court-and-family-court
      york-county-court-and-family-court
      harrogate-magistrates-court-and-family-court
      scarborough-justice-centre
      skipton-county-court-and-family-court
      central-family-court
      clerkenwell-and-shoreditch-county-court-and-family-court
      bury-st-edmunds-county-court-and-family-court
      southend-magistrates-court-and-family-court
      taunton-crown-county-and-family-court
      yeovil-county-family-and-magistrates-court
      norwich-combined-court-centre
      kings-lynn-magistrates-court-and-family-court
      luton-county-court-and-family-court
      bedford-county-court-and-family-court
      chelmsford-county-and-family-court
      southend-magistrates-court-and-family-court
      canterbury-combined-court-centre
      dartford-county-court-and-family-court
      maidstone-combined-court-centre
      hertford-county-court-and-family-court
      chester-civil-and-family-justice-centre
      crewe-county-court-and-family-court
      caernarfon-justice-centre
      wrexham-county-and-family-court
      welshpool-magistrates-court
      prestatyn-justice-centre
      blackwood-civil-and-family-court
      pontypridd-county-court-and-family-court
      port-talbot-justice-centre
      merthyr-tydfil-combined-court-centre
      aberystwyth-justice-centre
      carmarthen-county-court-and-family-court
      haverfordwest-county-court-and-family-court
      carmarthen-county-court-and-family-court
    ].freeze

    # Separate multiple postcodes/postcode areas by "\n"
    # Will return an array of courts to which the application
    # could be sent, based on the postcodes given.
    # If the courts serving the postcodes given are not
    # taking part in our service, they will not be returned
    def courts_for(postcodes)
      postcodes.to_s.split("\n").reject(&:blank?).map do |postcode|
        court_for(postcode)
      end.compact
    end

    def court_for(postcode)
      possible_courts = CourtfinderAPI.new.court_for(AREA_OF_LAW, postcode)
      choose_from(possible_courts)
    end

    private

    def choose_from(possible_courts)
      slug = nil
      first_with_slug = possible_courts.find do |court|
        slug = court[:slug] || court['slug']
      end
      first_with_slug if COURT_SLUGS_USING_THIS_APP.include?(slug)
    end
  end
end
