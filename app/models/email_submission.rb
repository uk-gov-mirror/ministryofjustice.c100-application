class EmailSubmission < ApplicationRecord
  belongs_to :c100_application

  # The following are utility methods used to manually trigger the emails.
  # Do not rely on these methods other than to force manual submissions in
  # case of bounces or errors.
  #
  # :nocov:
  def resend_court_email!
    update_column(:sent_at, nil)
    OnlineSubmissionJob.perform_later(c100_application)
  end

  def resend_user_email!
    update_column(:user_copy_sent_at, nil)
    OnlineSubmissionJob.perform_later(c100_application)
  end
  # :nocov:
end
