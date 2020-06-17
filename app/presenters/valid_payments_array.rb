class ValidPaymentsArray < SimpleDelegator
  COMMON_CHOICES = [
    PaymentType::HELP_WITH_FEES,
    PaymentType::SELF_PAYMENT_CARD,
    PaymentType::SELF_PAYMENT_CHEQUE,
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
      choices.append(PaymentType::ONLINE)    if c100_application.online_submission?
    end
  end
end
