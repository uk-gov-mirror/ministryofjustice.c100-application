class Court
  attr_reader :name, :slug, :email, :address

  # Using `fetch` so an exception is raised and we are alerted if the json
  # schema ever changes, instead of silently let the user continue, as all
  # details are needed for the application to progress
  #
  def initialize(data)
    @name = data.fetch('name')
    @slug = data.fetch('slug')
    @address = data.fetch('address')
    # The email, if not already present, comes from a separate API request
    @email = data['email'] || best_enquiries_email
  rescue StandardError => ex
    log_and_raise(ex, data)
  end

  def full_address
    [
      name,
      address.fetch_values(
        'address_lines',
        'town',
        'postcode',
      )
    ].flatten.reject(&:blank?).uniq
  end

  def best_enquiries_email
    # There's no consistency to how courts list their email address descriptions
    # So the order of priority is:
    #
    # 1. anything mentioning 'children'
    # 2. an 'applications' address
    # 3. anything mentioning 'family'
    # 4. a general 'enquiries' address
    # 5. just take the first

    emails = retrieve_emails_from_api

    best =  emails.find { |e| e['description'] =~ /children/i }         || \
            emails.find { |e| e['description'] =~ /\Aapplications\z/i } || \
            emails.find { |e| e['description'] =~ /family/i }           || \
            emails.find { |e| e['description'] =~ /\Aenquiries\z/i }    || \
            emails.first

    # We want this to raise a `KeyError` exception when no email is found
    best ||= {}
    best.fetch('address')
  end

  private

  def retrieve_emails_from_api
    this_court = C100App::CourtfinderAPI.new.court_lookup(slug)
    this_court.fetch('emails')
  end

  def log_and_raise(exception, data)
    Raven.extra_context(data: data)
    Raven.capture_exception(exception)
    raise
  end
end
