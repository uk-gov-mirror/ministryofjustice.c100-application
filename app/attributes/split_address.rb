class SplitAddress < Virtus::Attribute
  TOKEN_SEPARATOR = '|'.freeze

  def coerce(value)
    tokens = value.to_s.split(TOKEN_SEPARATOR)
    return nil if tokens.empty?

    {
      address_line_1: tokens[0],
      address_line_2: tokens[1],
      town: tokens[2],
      country: tokens[3],
      postcode: tokens[4],
    }
  end
end
