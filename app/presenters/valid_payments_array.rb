class ValidPaymentsArray < SimpleDelegator
  COMMON_CHOICES = [
    PaymentType::HELP_WITH_FEES,
    PaymentType::SELF_PAYMENT_CHEQUE,
  ].freeze

  # This is temporary as we open online payments to a few courts first,
  # before allowing the rest of courts to use it.
  COURTS_WITH_ONLINE_PAYMENT = %w[
    chelmsford-county-and-family-court
    chelmsford-magistrates-court-and-family-court
    west-london-family-court

    bristol-civil-and-family-justice-centre
    east-london-family-court
    leeds-combined-court-centre
    medway-county-court-and-family-court
    nottingham-county-court-and-family-court
    preston-crown-court-and-family-court-sessions-house
  ].freeze

  attr_reader :c100_application

  def initialize(c100_application)
    @c100_application = c100_application

    super(
      choices_to_present
    )
  end

  def include?(other)
    collection.include?(PaymentType.new(other.to_s))
  end

  private

  def collection
    __getobj__
  end

  def choices_to_present
    COMMON_CHOICES.dup.tap do |choices|
      choices.append(
        PaymentType::SOLICITOR
      ) if c100_application.has_solicitor?

      choices.append(
        PaymentType::ONLINE
      ) if govuk_pay_enabled?

      choices.append(
        PaymentType::SELF_PAYMENT_CARD
      ) if phone_pay_enabled?
    end
  end

  def govuk_pay_enabled?
    return false unless c100_application.online_submission?

    COURTS_WITH_ONLINE_PAYMENT.include?(
      c100_application.screener_answers_court.slug
    )
  end

  # Do not show `pay by phone` option if the application can
  # use online payment, or if it is print&post.
  #
  def phone_pay_enabled?
    return false unless c100_application.online_submission?

    !govuk_pay_enabled?
  end
end
