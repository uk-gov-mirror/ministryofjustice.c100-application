class ChildrenResidence < ValueObject
  VALUES = [
    APPLICANT  = new(:applicant),
    RESPONDENT = new(:respondent),
    OTHER      = new(:other)
  ].freeze

  def self.values
    VALUES
  end
end
