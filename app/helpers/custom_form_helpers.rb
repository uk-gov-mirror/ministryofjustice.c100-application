module CustomFormHelpers
  delegate :t,
           :current_c100_application,
           :user_signed_in?, to: :@template

  def continue_button(continue: :continue, save_and_continue: :save_and_continue)
    if save_and_return_disabled?
      submit_button(continue)
    elsif user_signed_in?
      submit_button(save_and_continue)
    else
      submit_button(continue) do
        draft_button(:save_and_come_back_later, secondary: true)
      end
    end
  end

  private

  def save_and_return_disabled?
    current_c100_application.nil? || current_c100_application.screening?
  end

  def submit_button(i18n_key, opts = {}, &block)
    govuk_submit t("helpers.submit.#{i18n_key}"), opts, &block
  end

  # Kind of hackish but `govuk_submit` does not currently accept `name` attribute
  def draft_button(i18n_key, opts = {})
    html = Nokogiri::HTML.fragment(
      submit_button(i18n_key, opts)
    ).at(:input)

    html['name'] = 'commit_draft'
    html.to_html.html_safe
  end
end
