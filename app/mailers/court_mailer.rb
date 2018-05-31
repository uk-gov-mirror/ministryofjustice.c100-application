class CourtMailer < SubmissionMailer
  def submission_to_court(c100_application:, from:, to:, reply_to:, attachment:)
    attachments[c100_application.id + '.pdf'] = attachment_contents(attachment)

    mail(
      to: to,
      from: from,
      reply_to: reply_to
    )
  end
end
