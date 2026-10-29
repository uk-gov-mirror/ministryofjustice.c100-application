class Court < ApplicationRecord
  include CourtContactDetails

  REFRESH_DATA_AFTER = 72.hours
  UNKNOWN_GBS = 'unknown'.freeze

  has_many :c100_applications

  alias_attribute :slug, :id
  alias_attribute :family_location_code, :cci_code

  # Using `fetch` so an exception is raised and we are alerted if the json
  # schema ever changes, instead of silently let the user continue, as all
  # details are needed for the application to progress
  #
  def self.build(data)
    new(
      slug: data.fetch('slug'),
      name: data.fetch('name'),
      address: fetch_address(data),
      cci_code: data.fetch('courtCodes').first&.fetch('countyCourtCode', nil),
      email: data['courtContactDetails']&.find { |contact| contact['email'].present? }&.fetch('email', nil),
      gbs: data.fetch('courtCodes').first&.fetch('gbs', nil)
    )
  rescue StandardError => ex
    log_and_raise(ex, data)
  end

  # If this is the first time we see this court (slug) then we create
  # a new record in the `courts` table. If we already have this court,
  # we check if its data has become stale, and if so, we refresh it.
  #
  def self.create_or_refresh(data)
    court = find_or_initialize_by(slug: data.fetch('slug'))

    if court.stale?
      court.update(
        name: data.fetch('name'),
        address: fetch_address(data),
        cci_code: data.fetch('courtCodes').first&.fetch('countyCourtCode', nil),
        email: data['courtContactDetails']&.find { |contact| contact['email'].present? }&.fetch('email', nil),
        gbs: data.fetch('courtCodes').first&.fetch('gbs', nil),
        updated_at: Time.now
      )
    end

    court
  rescue StandardError => ex
    log_and_raise(ex, data)
  end

  def email=(email)
    self[:email] = email || best_enquiries_email
  end

  def gbs=(gbs)
    self[:gbs] = gbs || retrieve_gbs_from_api
  end

  def best_enquiries_email
    # There's no consistency to how courts list their email addresses, so we try to find
    # the most suitable one by looking for keywords.
    #
    # We prioritise the `explanation` field, and look for the `c100` keyword, as many of
    # the courts will have an email entry with the words "Including C100 applications".
    #
    # After that, if no match is found, we look in the address itself, and if no match
    # is found, as a last resort we try to find an email containing the word `enquiries`,
    # and if still nothing is found, we pick the first entry.
    #
    emails = retrieve_emails_from_api
    best = best_match_in_explanation(emails) ||
           best_match_in_address(emails) ||
           fallback_address(emails)

    # We want this to raise a `KeyError` exception when no email is found
    best ||= {}
    best.fetch('address')
  end

  def gbs_known?
    !gbs.eql?(UNKNOWN_GBS)
  end

  def stale?
    updated_at.nil? || updated_at <= REFRESH_DATA_AFTER.ago
  end

  def self.fetch_address(data)
    data.fetch('courtAddresses').find do |item|
      item['addressType'] == 'VISIT_OR_CONTACT_US'
    end || data.fetch('courtAddresses').first
  end

  private

  def best_match_in_address(emails)
    emails.find { |e| e['address'] =~ /c100/i }       || \
      emails.find { |e| e['address'] =~ /family/i }   || \
      emails.find { |e| e['address'] =~ /children/i }
  end

  def best_match_in_explanation(emails)
    emails.find { |e| e['explanation'] =~ /c100/i }
  end

  def fallback_address(emails)
    emails.find { |e| e['address'] =~ /enquiries/i } || emails.first
  end

  def retrieve_gbs_from_api
    court_data.fetch('courtCodes').first.fetch('gbs').presence || UNKNOWN_GBS
  end

  def retrieve_emails_from_api
    court_data.fetch('courtContactDetails').map do |contact|
      {
        'address' => contact.fetch('email'),
        'description' => contact.dig('courtContactDescription', 'name'),
        'explanation' => contact['explanation'],
      }
    end
  end

  def court_data
    @_court_data ||= C100App::NewCourtfinderApi.new.court_lookup(slug)
  end

  def self.log_and_raise(exception, data)
    Sentry.with_scope do |scope|
      scope.set_extras(data:)
      Sentry.capture_exception(exception)
    end

    raise
  end
  private_class_method :log_and_raise
end
