class NotifyMailer < GovukNotifyRails::Mailer
  rescue_from Exception, with: :log_errors

  # When logging exceptions, filter the following keys from the personalisation hash
  FILTERED = '[FILTERED]'.freeze
  PERSONALISATION_ERROR_FILTER = [
    :recipient_name,
    :reset_url
  ].freeze

  # Define methods as usual, and set the template and personalisation, if needed,
  # then just use mail() as with any other ActionMailer, with the recipient email

  # Triggered automatically by Devise when the user resets its password
  def reset_password_instructions(user, token, _opts = {})
    set_template(ENV.fetch('NOTIFY_RESET_PASSWORD_TEMPLATE_ID'))

    set_personalisation(
      reset_url: edit_user_password_url(reset_password_token: token)
    )

    mail(to: user.email)
  end

  # Triggered automatically by Devise when the user changes its password
  def password_change(user, _opts = {})
    set_template(ENV.fetch('NOTIFY_CHANGE_PASSWORD_TEMPLATE_ID'))

    # set_personalisation(
    #   portfolio_url: users_cases_url
    # )

    mail(to: user.email)
  end

  private

  def log_errors(exception)
    Rails.logger.info({caller: self.class.name, method: action_name, error: exception}.to_json)

    Raven.extra_context(
      template_id: govuk_notify_template,
      personalisation: filtered_personalisation
    )
    Raven.capture_exception(exception)
  end

  def filtered_personalisation
    personalisation = govuk_notify_personalisation&.dup || {}
    personalisation.each_key do |key|
      personalisation[key] = FILTERED if filter_key?(key)
    end
  end

  def filter_key?(key)
    PERSONALISATION_ERROR_FILTER.include?(key)
  end
end
