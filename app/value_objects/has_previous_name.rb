class HasPreviousName < ValueObject
  VALUES = [
    YES = new(:yes),
    NO  = new(:no),
    UNKNOWN = new(:unknown)
  ].freeze

  def self.values
    VALUES
  end
end
