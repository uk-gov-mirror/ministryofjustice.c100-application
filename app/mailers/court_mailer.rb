class CourtMailer < SubmissionMailer
  def submission_to_court(to:, reply_to:)
    attach_c100_pdf!

    mail(
      to: to,
      reply_to: reply_to
    )
  end
end
