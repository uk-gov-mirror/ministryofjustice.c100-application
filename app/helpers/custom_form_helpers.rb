module CustomFormHelpers
  delegate :t,
           :current_c100_application,
           :user_signed_in?,
           :new_user_registration_path, to: :@template

  def continue_button
    content_tag(:div, class: 'form-submit') do
      if save_and_return_disabled?
        submit_button(:continue)
      elsif user_signed_in?
        submit_button(:save_and_continue)
      else
        safe_concat [
          submit_button(:continue),
          content_tag(:a, t('helpers.submit.save_and_come_back_later'), href: new_user_registration_path, class: 'button button-secondary button-save-return')
        ].join
      end
    end
  end

  def single_check_box(attribute, options = {})
    content_tag(:div, merge_attributes(options, default: {class: 'multiple-choice single-cb', id: form_group_id(attribute)})) do
      safe_concat [
        check_box(attribute),
        label(attribute) { localized_label(attribute) }
      ].join
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
