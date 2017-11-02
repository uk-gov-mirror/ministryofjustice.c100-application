class Gender < ValueObject
  VALUES = [
    FEMALE = new(:female),
    MALE   = new(:male)
  ].freeze

  def self.values
    VALUES
  end
end
