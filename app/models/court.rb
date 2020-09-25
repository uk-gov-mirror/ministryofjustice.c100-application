class Court < ApplicationRecord
  REFRESH_DATA_AFTER = 72.hours
  UNKNOWN_GBS = 'unknown'.freeze

  has_many :c100_applications

  alias_attribute :slug, :id

  # Using `fetch` so an exception is raised and we are alerted if the json
  # schema ever changes, instead of silently let the user continue, as all
  # details are needed for the application to progress
  #
  def self.build(data)
    new(
      slug: data.fetch('slug'),
      name: data.fetch('name'),
      address: data.fetch('address'),
      # Email and GBS code, if not already present, come from a separate API request
      email: data['email'],
      gbs: data['gbs'],
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
      court.slug_will_change! # Touch `updated_at` on save, even if there are no changes

      court.update_attributes(
        build(data).attributes.except('created_at', 'updated_at')
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
    # There's no consistency to how courts list their email address descriptions,
    # so we try to find the most suitable email address, by looking at the `explanation`
    # or the `description` for each of the emails, or the actual email address,
    # and if none is found, as a last resort we try to find an email address containing
    # the `enquiries` word and if still nothing is found, we pick the first entry.
    #
    emails = retrieve_emails_from_api
    best = best_match_for(emails, 'explanation') ||
           best_match_for(emails, 'description') ||
           best_match_for(emails, 'address') ||
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

  private

  def best_match_for(emails, node)
    emails.find { |e| e[node] =~ /children/i }       || \
      emails.find { |e| e[node] =~ /applications/i } || \
      emails.find { |e| e[node] =~ /family/i }
  end

  def fallback_address(emails)
    emails.find { |e| e['address'] =~ /enquiries/i } || emails.first
  end

  def retrieve_gbs_from_api
    court_data.fetch('gbs').presence || UNKNOWN_GBS
  end

  def retrieve_emails_from_api
    court_data.fetch('emails')
  end

  def court_data
    @_court_data ||= C100App::CourtfinderAPI.new.court_lookup(slug)
  end

  def self.log_and_raise(exception, data)
    Raven.extra_context(data: data)
    Raven.capture_exception(exception)
    raise
  end
  private_class_method :log_and_raise
end
