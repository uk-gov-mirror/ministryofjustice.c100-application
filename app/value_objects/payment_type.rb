class PaymentType < ValueObject
  VALUES = [
    HELP_WITH_FEES = new(:help_with_fees),
    SOLICITOR = new(:solicitor),
    SELF_PAYMENT = new(:self_payment),
  ].freeze

  def self.values
    VALUES
  end
end
