class PaymentType < ValueObject
  VALUES = [
    HELP_WITH_FEES = new(:help_with_fees),
    # TODO: we are not showing the `solicitor` option currently, but all
    # is in place to re-enable it at any time, with minimal changes.
    SOLICITOR = new(:solicitor),
    SELF_PAYMENT_CARD = new(:self_payment_card),
    SELF_PAYMENT_CHEQUE = new(:self_payment_cheque),
  ].freeze

  def self.values
    VALUES
  end
end
