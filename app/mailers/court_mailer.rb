class CourtMailer < SmtpSubmissionMailer
  def submission_to_court(to:)
    attach_c100_pdf!

    # A 'real' application would never reach this point without having at
    # least 1 applicant, but on staging and local, we may jump steps and
    # don't want this to explode, thus, protecting from `nil`.
    @applicant_full_name = @c100_application.applicants.first&.full_name

    mail(
      to: to,
      subject: submission_to_court_subject,
    )
  end

  private

  def submission_to_court_subject
    i18n_key = if @c100_application.urgent_hearing.eql?(GenericYesNo::YES.to_s)
                 :urgent_subject
               else
                 :subject
               end

    I18n.translate!(i18n_key, scope: [:court_mailer, :submission_to_court])
  end
end
