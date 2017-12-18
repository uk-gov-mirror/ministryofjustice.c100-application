class PetitionOrder < ValueObject
  VALUES = [
    CHILD_ARRANGEMENTS = [
      new(:child_home),
      new(:child_times),
      new(:child_contact)
    ].freeze,

    SPECIFIC_ISSUES = [
      new(:child_specific_issue_school),
      new(:child_specific_issue_religion),
      new(:child_specific_issue_name),
      new(:child_specific_issue_medical),
      new(:child_specific_issue_abroad),
      new(:child_return)
    ].freeze,

    PROHIBITED_STEPS = [
      new(:child_abduction),
      new(:child_flight)
    ].freeze,

    OTHER = [
      new(:other)
    ].freeze
  ].flatten.freeze

  def self.values
    VALUES
  end
end
