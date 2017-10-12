class CaseType < ValueObject
  def self.find_constant(raw_value)
    const_get(raw_value.upcase)
  end

  def initialize(raw_value, params = {})
    super(raw_value)
  end

  VALUES = [
    CHILD_ARRANGEMENTS = new(:child_arrangements),
    PROHIBITED_STEPS = new(:prohibited_steps),
    SPECIFIC_ISSUE = new(:specific_issue)
  ].freeze

  def self.values
    VALUES
  end
end
