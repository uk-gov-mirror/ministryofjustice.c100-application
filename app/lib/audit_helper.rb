class AuditHelper
  attr_reader :c100_application
  alias_attribute :c100, :c100_application

  def initialize(c100_application)
    @c100_application = c100_application
  end

  def metadata
    {
      v: c100.version,
      postcode: postcode,
      c1a_form: c100.has_safety_concerns?,
      c8_form: c100.confidentiality_enabled?,
      saved_for_later: c100.user_id.present?,
      legal_representation: c100.has_solicitor,
      urgent_hearing: c100.urgent_hearing,
      without_notice: c100.without_notice,
      reduced_litigation: c100.reduced_litigation_capacity,
      payment_type: c100.payment_type,
      signee_capacity: c100.declaration_signee_capacity,
      arrangements: arrangements_metadata,
    }
  end

  private

  def arrangement
    @_arrangement ||= c100.court_arrangement
  end

  def postcode
    # We blind a bit the postcode to anonymize it
    postcode = c100.screener_answers.children_postcodes
    postcode.sub(/\s+/, '').upcase.at(0..-3) + '**'
  end

  def arrangements_metadata
    return [] unless arrangement.present?

    [].tap do |options|
      options << 'intermediary' if arrangement.intermediary_help.eql?(GenericYesNo::YES.to_s)
      options << arrangement.language_options
      options << arrangement.special_arrangements
      options << arrangement.special_assistance
    end.flatten
  end
end
