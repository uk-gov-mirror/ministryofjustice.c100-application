class C8ConfidentialityPresenter < SimpleDelegator
  attr_reader :c100_application

  PEOPLE_UNDER_C8 = [
    Applicant,
    OtherParty,
  ].freeze

  DETAILS_UNDER_C8 = [
    :address,
    :residence_history,
    :home_phone,
    :mobile_phone,
    :email,
  ].freeze

  def initialize(person, c100_application)
    @c100_application = c100_application
    super(person)
  end

  def method_missing(name, *args, &block)
    confidential_detail?(name, super) ? replacement_answer : super
  end

  private

  def confidential_detail?(attribute, value)
    DETAILS_UNDER_C8.include?(attribute) && value.present? && confidentiality_enabled?
  end

  def confidentiality_enabled?
    @_confidentiality_enabled ||= begin
      PEOPLE_UNDER_C8.include?(__getobj__.class) &&
        c100_application.address_confidentiality.eql?(GenericYesNo::YES.to_s)
    end
  end

  def replacement_answer
    @_replacement_answer ||= I18n.translate!('shared.c8_confidential_answer')
  end
end
