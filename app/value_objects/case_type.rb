class CaseType < ValueObject
  VALUES = [
    CHILD_ARRANGEMENTS = new(:child_arrangements),
    PROHIBITED_STEPS   = new(:prohibited_steps),
    SPECIFIC_ISSUE     = new(:specific_issue)
  ].freeze

  def self.values
    VALUES
  end
end
