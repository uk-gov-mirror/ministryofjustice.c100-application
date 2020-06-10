module ApplicationInquiryMethods
  def online_submission?
    submission_type.eql?(SubmissionType::ONLINE.to_s)
  end

  # TODO: change when we introduce the 'real' online payment method
  def online_payment?
    payment_type.eql?(PaymentType::SELF_PAYMENT_CARD.to_s)
  end

  def confidentiality_enabled?
    address_confidentiality.eql?(GenericYesNo::YES.to_s)
  end

  def has_solicitor?
    has_solicitor.eql?(GenericYesNo::YES.to_s)
  end

  def has_safety_concerns?
    [
      domestic_abuse,
      risk_of_abduction,
      children_abuse,
      substance_abuse,
      other_abuse
    ].any? { |concern| concern.eql?(GenericYesNo::YES.to_s) }
  end
end
