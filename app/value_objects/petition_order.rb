class PetitionOrder < ValueObject
  VALUES = [
    CHILD_ARRANGEMENTS = [
      new(:child_arrangements_home),
      new(:child_arrangements_time),
      new(:child_arrangements_contact),
      new(:child_arrangements_access),
    ].freeze,

    GROUP_PROHIBITED_STEPS = new(:group_prohibited_steps),
    PROHIBITED_STEPS = [
      new(:prohibited_steps_moving),
      new(:prohibited_steps_moving_abroad),
      new(:prohibited_steps_names),
      new(:prohibited_steps_medical),
      new(:prohibited_steps_holiday),
    ].freeze,

    GROUP_SPECIFIC_ISSUES = new(:group_specific_issues),
    SPECIFIC_ISSUES = [
      new(:specific_issues_holiday),
      new(:specific_issues_school),
      new(:specific_issues_religion),
      new(:specific_issues_names),
      new(:specific_issues_medical),
      new(:specific_issues_moving),
      new(:specific_issues_moving_abroad),
    ].freeze,

    OTHER_ISSUE = new(:other_issue),
  ].flatten.freeze

  def self.values
    VALUES
  end
end
