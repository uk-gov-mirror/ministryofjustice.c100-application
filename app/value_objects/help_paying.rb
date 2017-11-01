class HelpPaying < ValueObject
  VALUES = [
    YES_WITH_REF_NUMBER = new(:yes_with_ref_number),
    YES_WITHOUT_REF_NUMBER = new(:yes_without_ref_number),
    NOT_NEEDED = new(:not_needed)
  ].freeze

  def self.values
    VALUES
  end
end
