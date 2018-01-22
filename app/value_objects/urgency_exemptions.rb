class UrgencyExemptions < ValueObject
  VALUES = [
    GROUP_RISK = new(:group_risk),
    RISK = [
      new(:risk_applicant),
      new(:risk_unreasonable_hardship),
      new(:risk_children),
      new(:risk_unlawful_removal_retention)
    ].freeze,

    GROUP_MISCARRIAGE = new(:group_miscarriage),
    MISCARRIAGE = [
      new(:miscarriage_justice),
      new(:miscarriage_irretrievable_problems)
    ].freeze,

    URGENCY_NONE = new(:urgency_none)
  ].flatten.freeze

  # :nocov:
  def self.values
    VALUES
  end
  # :nocov:
end
