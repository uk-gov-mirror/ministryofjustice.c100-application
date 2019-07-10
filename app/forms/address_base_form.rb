class AddressBaseForm < BaseForm
  attribute :address_unknown, Boolean, default: false
  attribute :address_line_1, StrippedString
  attribute :address_line_2, StrippedString
  attribute :town, StrippedString
  attribute :country, StrippedString
  attribute :postcode, StrippedString

  validates_presence_of :address_line_1, unless: :address_unknown?
  validates_presence_of :town, unless: :address_unknown?

  private

  def address_values
    {
      address_data: {
        address_line_1: address_line_1,
        address_line_2: address_line_2,
        town: town,
        country: country,
        postcode: postcode,
      },
      address_unknown: address_unknown,
    }
  end
end
