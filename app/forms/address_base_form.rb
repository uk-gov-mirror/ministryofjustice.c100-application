class AddressBaseForm < BaseForm
  attribute :address, StrippedString
  attribute :address_unknown, Boolean, default: false

  attribute :address_line_1, StrippedString
  attribute :address_line_2, StrippedString
  attribute :town, StrippedString
  attribute :country, StrippedString
  attribute :postcode, StrippedString

  validates_presence_of :address, unless: :validate_address?

  validates_presence_of :address_line_1, if: :validate_split_address?
  validates_presence_of :town, if: :validate_split_address?

  def validate_address?
    [address_unknown?, split_address?].any?
  end

  def validate_split_address?
    address_unknown?.equal?(false) && split_address?
  end

  private

  def update_values
    return address_split_values if split_address?
    address_values
  end

  def address_values
    {
      address: address,
      address_unknown: address_unknown,
    }
  end

  def address_split_values
    {
      address_data: address_hash,
      address_unknown: address_unknown,
    }
  end

  def address_hash
    {
      address_line_1: address_line_1,
      address_line_2: address_line_2,
      town: town,
      country: country,
      postcode: postcode
    }
  end
end
