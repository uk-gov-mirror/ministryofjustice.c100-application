class CompletedApplicationsAudit < ApplicationRecord
  self.table_name = 'completed_applications_audit'

  default_scope { order(completed_at: :asc) }

  def self.log!(c100_application)
    create(
      started_at: c100_application.created_at,
      completed_at: c100_application.updated_at,
      saved: c100_application.user_id.present?,
      submission_type: c100_application.submission_type,
      court: c100_application.screener_answers_court&.name,
    )
  end
end
