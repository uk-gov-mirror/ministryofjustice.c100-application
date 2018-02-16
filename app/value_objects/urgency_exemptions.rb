class UrgencyExemptions < ValueObject
  VALUES = [
    RISK_APPLICANT = new(:risk_applicant),
    UNREASONABLE_HARDSHIP = new(:unreasonable_hardship),

    GROUP_RISK = new(:group_risk),
    RISK = [
      new(:risk_children),
      new(:risk_unlawful_removal_retention)
    ].freeze,

    MISCARRIAGE_JUSTICE = new(:miscarriage_justice),
    IRRETRIEVABLE_PROBLEMS = new(:irretrievable_problems),
    INTERNATIONAL_PROCEEDINGS = new(:international_proceedings),

    URGENCY_NONE = new(:urgency_none)
  ].flatten.freeze

  # :nocov:
  def self.values
    VALUES
  end
  # :nocov:
end
