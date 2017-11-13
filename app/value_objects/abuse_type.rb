class AbuseType < ValueObject
  VALUES = [
    SUBSTANCES    = new(:substances),
    PHYSICAL      = new(:physical),
    EMOTIONAL     = new(:emotional),
    PSYCHOLOGICAL = new(:psychological),
    SEXUAL        = new(:sexual),
    FINANCIAL     = new(:financial),
    OTHER         = new(:other)
  ].freeze

  def self.values
    VALUES
  end
end
