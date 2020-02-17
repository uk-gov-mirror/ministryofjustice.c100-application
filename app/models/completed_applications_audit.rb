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
    AuditHelper.new(c100_application).metadata
  end

  # This will be `nil` if the application has been purged from database already
  def c100_application
    C100Application.find_by_reference_code(reference_code)
  end
end
