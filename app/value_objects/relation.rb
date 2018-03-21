class Relation < ValueObject
  VALUES = [
    MOTHER = new(:mother),
    FATHER = new(:father),
    OTHER  = new(:other),
  ].freeze

  def self.values
    VALUES
  end
end
