class PersonType < ValueObject
  VALUES = [
    APPLICANT   = new(:applicant),
    RESPONDENT  = new(:respondent),
    CHILD       = new(:child),
    OTHER_CHILD = new(:other_child),
    OTHER_PARTY = new(:other_party)
  ].freeze
end
