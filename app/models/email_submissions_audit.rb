class EmailSubmissionsAudit < ApplicationRecord
  self.table_name = 'email_submissions_audit'

  default_scope { order(completed_at: :asc) }

  class << self
    require 'bcrypt'

    # :nocov:
    def find_records(reference, email)
      EmailSubmissionsAudit.where(reference: reference).select do |record|
        BCrypt::Password.new(record.to) == email.downcase
      end
    end
    # :nocov:
  end
end
