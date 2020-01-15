class CompletedApplicationsAudit < ApplicationRecord
  self.table_name  = 'completed_applications_audit'
  self.primary_key = :reference_code

  default_scope { order(completed_at: :asc) }

  def self.log!(c100_application)
    create(
      started_at: c100_application.created_at,
      completed_at: c100_application.updated_at,
      reference_code: c100_application.reference_code,
      submission_type: c100_application.submission_type,
      court: c100_application.screener_answers_court.name,
      metadata: metadata(c100_application),
    )
  end

  def self.metadata(c100_application)
    # We blind a bit the postcode to anonymize it
    postcode = c100_application.screener_answers.children_postcodes
    postcode = postcode.sub(/\s+/, '').upcase.at(0..-3) + '**'

    {
      postcode: postcode,
      c1a_form: c100_application.has_safety_concerns?,
      c8_form: c100_application.confidentiality_enabled?,
      saved_for_later: c100_application.user_id.present?,
      legal_representation: c100_application.has_solicitor,
      urgent_hearing: c100_application.urgent_hearing,
      without_notice: c100_application.without_notice,
      payment_type: c100_application.payment_type,
      signee_capacity: c100_application.declaration_signee_capacity,
    }
  end

  # This will be `nil` if the application has been purged from database already
  def c100_application
    C100Application.find_by_reference_code(reference_code)
  end
end
