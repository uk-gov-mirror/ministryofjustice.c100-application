class EmailSubmissionsAudit < ApplicationRecord
  self.table_name = 'email_submissions_audit'

  default_scope { order(completed_at: :asc) }

  class << self
    require 'bcrypt'

    # Note: reference is the email reference, and starts with prefix
    # `user` or `court`, followed by the application reference code.
    # Refer to `mailers/notify_submission_mailer.rb`
    #
    # Email is optional. If not provided, all records matching the
    # `reference` will be returned. Otherwise it will return only the
    # records matching the exact reference and email (email is hashed).
    #
    # :nocov:
    def find_records(reference, email = nil)
      EmailSubmissionsAudit.where(reference: reference).select do |record|
        email.blank? || BCrypt::Password.new(record.to) == email.downcase
      end
    end
    # :nocov:
  end
end
