class NotifySubmissionMailer < NotifyMailer
  #
  # Notify doesn't care about the `from` address, but we use it in the interceptor.
  #
  # It can be `nil`, as the interceptor will then make Notify fail email validation,
  # which is a valid outcome when testing on local or staging environments.
  #
  default from: -> { @c100_application.receipt_email }

  before_action do
    @c100_application = params[:c100_application]
    @c100_pdf = params[:c100_pdf]
    @c100_pdf.rewind # ensure we are always at the beginning of the file
  end

  #
  # Note: when some values are `nil`, we set a default. The only purpose of this
  # is to be able to use the `bypass` functionality on test environments, without
  # having to fill the whole application.
  #

  def application_to_court(to_address:)
    set_template(:application_submitted_to_court)

    set_personalisation(
      shared_personalisation.merge(
        urgent: @c100_application.urgent_hearing || 'no',
        c8_included: @c100_application.address_confidentiality || 'no',
      )
    )

    mail(to: to_address)
  end

  def application_to_user(to_address:)
    set_template(:application_submitted_to_user)

    set_personalisation(
      shared_personalisation.merge(
        court_name: court.name,
        court_email: court.email,
        court_url: C100App::CourtfinderAPI.new.court_url(court.slug),
        payment_instructions: payment_instructions,
      )
    )

    mail(to: to_address)
  end

  private

  def shared_personalisation
    {
      applicant_name: @c100_application.applicants.first&.full_name || '[name not entered]',
      reference_code: @c100_application.reference_code,
      link_to_pdf: Notifications.prepare_upload(@c100_pdf),
    }
  end

  def payment_instructions
    I18n.translate!(
      @c100_application.payment_type || PaymentType::SELF_PAYMENT_CARD,
      scope: [:notify_submission_mailer, :payment_instructions]
    )
  end

  def court
    @c100_application.screener_answers_court
  end
end
