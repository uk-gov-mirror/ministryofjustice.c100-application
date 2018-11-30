class EmailSubmissionsAudit < ApplicationRecord
  self.table_name = 'email_submissions_audit'

  default_scope { order(completed_at: :asc) }
end
