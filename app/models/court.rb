class Court
  attr_accessor :name, :address_lines, :town, :postcode, :phone_number, :slug

  def initialize(params = nil)
    return unless params
    params.each do |key, val|
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
    if (given_address = court_finder_data['address'])
      parse_given_address!(given_address)
    end
    parse_basic_attributes!(court_finder_data)
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
end
