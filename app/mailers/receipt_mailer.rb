class ReceiptMailer < SmtpSubmissionMailer
  def copy_to_user(to:, reply_to:)
    attach_c100_pdf!

    @court = @c100_application.screener_answers_court

    mail(
      to: to,
      reply_to: reply_to
    )
  end
end
