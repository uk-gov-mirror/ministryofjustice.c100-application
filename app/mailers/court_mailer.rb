class CourtMailer < SubmissionMailer
  def submission_to_court(to:, reply_to:)
    attach_c100_pdf!

    # A 'real' application would never reach this point without having at
    # least 1 applicant, but on staging and local, we may jump steps and
    # don't want this to explode, thus, protecting from `nil`.
    @applicant_full_name = @c100_application.applicants.first&.full_name

    mail(
      to: to,
      reply_to: reply_to
    )
  end
end
