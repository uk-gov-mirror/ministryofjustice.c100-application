class Relation < ValueObject
  VALUES = [
    MOTHER         = new(:mother),
    FATHER         = new(:father),
    LEGAL_GUARDIAN = new(:legal_guardian),
    GRANDPARENT    = new(:grandparent),
    RELATIVE       = new(:relative),
    FAMILY_FRIEND  = new(:family_friend),
    SOCIAL_WORKER  = new(:social_worker),
    OTHER          = new(:other)
  ].freeze

  def self.values
    VALUES
  end
end
