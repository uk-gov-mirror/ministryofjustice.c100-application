class AbuseType < ValueObject
  VALUES = [
    SUBSTANCE     = new(:substance),
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
