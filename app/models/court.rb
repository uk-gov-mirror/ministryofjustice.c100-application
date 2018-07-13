require 'open-uri'

class Court
  attr_accessor :name, :address_lines, :town, :postcode, :phone_number, :slug,
                :email, :opening_times

  def initialize(params = nil)
    params.to_h.each do |key, val|
      setter = (key.to_s + '=')
      public_send(setter, val) if respond_to?(setter)
    end
  end

  # NOTE: this is not done in the initializer, as we want to
  # 1) create a Court from courtfinder data
  # 2) store just a subset of the courtfinder fields
  # 3) de-serialize those fields into a Court object
  # ...mixing up 1 & 3 in the initializer gets messy.
  def from_courtfinder_data!(court_finder_data)
    return self unless court_finder_data
    if (given_address = court_finder_data['address'])
      parse_given_address!(given_address)
    elsif court_finder_data['address_lines']
      parse_given_address!(court_finder_data)
    end
    parse_basic_attributes!(court_finder_data)
    merge_from_full_json_dump!
    self
  end

  def parse_basic_attributes!(given_attributes)
    self.name = given_attributes['name']
    self.slug = given_attributes['slug']
    self.phone_number = given_attributes['number']
  end

  def parse_given_address!(given_address)
    self.address_lines = given_address['address_lines']
    self.town = given_address['town']
    self.postcode = given_address['postcode']
  end

  def address
    addr = [address_lines, town, postcode].flatten
    addr.reject(&:blank?).uniq
  end

  def opening_times?
    opening_times.instance_of?(Array) && opening_times.any?
  end

  def self.all(params = {})
    C100App::CourtfinderAPI.new.all(cache_ttl: params[:cache_ttl] || 86_400)
  end

  protected

  def merge_from_full_json_dump!
    this_court = Court.all.find { |c| c.respond_to?(:fetch) && c.fetch('slug') == slug }
    return unless this_court
    self.email = best_enquiries_email(this_court['emails'])
    self.opening_times = this_court['opening_times'].to_a.map { |e| e['opening_time'] }
  end

  def best_enquiries_email(emails)
    # There's no consistency to how courts list their email address descriptions
    # So the order of priority is:
    #
    # 1. anything mentioning 'children'
    # 2. anything mentioning 'family applications' or 'family', in that order
    # 3. a general 'enquiries' address
    # 4. just take the first

    emails = Array(emails).compact

    best =  emails.find { |e| e['description'] =~ /children/i }                  || \
            emails.find { |e| e['description'] =~ /family applications/i }       || \
            emails.find { |e| e['description'] =~ /family/i }                    || \
            emails.find { |e| e['description'].to_s.casecmp('enquiries').zero? } || \
            emails.first

    best.fetch('address') if best.respond_to?(:fetch)
  end
end
