module CustomFormHelpers
  delegate :t,
           :current_c100_application,
           :user_signed_in?,
           :new_user_registration_path, to: :@template

  def continue_button
    content_tag(:p, class: 'actions') do
      if save_and_return_disabled?
        submit_button(:continue)
      elsif user_signed_in?
        submit_button(:save_and_continue)
      else
        safe_concat [
          submit_button(:continue),
          content_tag(:a, t('helpers.submit.save_and_come_back_later'), href: new_user_registration_path)
        ].join
      end
    end
  end

  private

  def save_and_return_disabled?
    current_c100_application.nil? || current_c100_application.screening?
  end

  def submit_button(i18n_key)
    submit t("helpers.submit.#{i18n_key}"), class: 'button'
  end
end
