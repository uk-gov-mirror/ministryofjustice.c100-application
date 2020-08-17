class ValidPaymentsArray < SimpleDelegator
  COMMON_CHOICES = [
    PaymentType::HELP_WITH_FEES,
    PaymentType::SELF_PAYMENT_CARD,
    PaymentType::SELF_PAYMENT_CHEQUE,
  ].freeze

  # This is temporary as we open online payments to a few courts first,
  # before allowing the rest of courts to use it.
  COURTS_WITH_ONLINE_PAYMENT = %w[
    chelmsford-county-and-family-court
    chelmsford-magistrates-court-and-family-court
    west-london-family-court
  ].freeze

  def initialize(c100_application)
    super(
      choices_to_present(c100_application)
    )
  end

  def include?(other)
    collection.include?(PaymentType.new(other.to_s))
  end

  private

  def collection
    __getobj__
  end

  def choices_to_present(c100_application)
    COMMON_CHOICES.dup.tap do |choices|
      choices.append(PaymentType::SOLICITOR) if c100_application.has_solicitor?
      choices.append(PaymentType::ONLINE)    if govuk_pay_enabled_for(c100_application)
    end
  end

  def govuk_pay_enabled_for(c100_application)
    return unless c100_application.online_submission?

    COURTS_WITH_ONLINE_PAYMENT.include?(
      c100_application.screener_answers_court.slug
    )
  end
end
