class UserType < ValueObject
  VALUES = [
    THEMSELF = new(:themself),
    REPRESENTATIVE = new(:representative)
  ].freeze

  def self.values
    VALUES
  end
end
