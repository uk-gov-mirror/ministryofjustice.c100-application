class C8ConfidentialityPresenter < SimpleDelegator
  DETAILS_UNDER_C8 = [
    :address,
    :full_address,
    :residence_history,
    :home_phone,
    :mobile_phone,
    :email,
  ].freeze

  def self.replacement_answer
    I18n.translate!('shared.c8_confidential_answer')
  end

  def method_missing(name, *args, &block)
    confidential_detail?(name, super) ? replacement_answer : super
  end

  private

  # This is just to remove from the logs:
  #   `warning: delegator does not forward private method #to_ary`
  def to_ary
    [self]
  end

  def confidential_detail?(attribute, value)
    DETAILS_UNDER_C8.include?(attribute) && value.present?
  end

  def replacement_answer
    @_replacement_answer ||= self.class.replacement_answer
  end
end
