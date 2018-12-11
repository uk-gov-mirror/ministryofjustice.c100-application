class EmailSubmission < ApplicationRecord
  belongs_to :c100_application

  # The following are utility methods used to manually trigger the emails.
  # Do not rely on these methods other than to force manual submissions in
  # case of bounces or errors.
  #
  # :nocov:
  def resend_court_email!
    CourtDeliveryJob.perform_later(c100_application)
  end

  def resend_user_email!
    ApplicantDeliveryJob.perform_later(c100_application)
  end
  # :nocov:
end
