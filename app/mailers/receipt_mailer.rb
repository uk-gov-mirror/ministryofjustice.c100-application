class ReceiptMailer < SubmissionMailer
  def copy_to_user(to:, reply_to:)
    attach_c100_pdf!

    mail(
      to: to,
      reply_to: reply_to
    )
  end
end
