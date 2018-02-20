class Gender < ValueObject
  VALUES = [
    FEMALE   = new(:female),
    MALE     = new(:male),
    INTERSEX = new(:intersex),
  ].freeze

  def self.values
    VALUES
  end
end
