class SessionsController < ApplicationController
  skip_before_action :ensure_session_validity, only: [:destroy]

  def ping
    head(:no_content)
  end

  def destroy
    reset_session

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: {} }
    end
  end

  # :nocov:
  def bypass_screener
    raise 'For development use only' unless helpers.dev_tools_enabled?

    find_or_create_screener_answers
    c100_application.update(status: 1)

    redirect_to entrypoint_v1_path
  end

  def bypass_to_cya
    raise 'For development use only' unless helpers.dev_tools_enabled?

    find_or_create_screener_answers
    c100_application.update(status: 1)

    redirect_to edit_steps_application_check_your_answers_path
  end
  # :nocov:

  private

  # :nocov:
  def c100_application
    current_c100_application || initialize_c100_application
  end

  def find_or_create_screener_answers
    ScreenerAnswers.find_or_initialize_by(c100_application_id: c100_application.id).tap do |screener|
      screener.update(
        screener_answers_fixture(screener)
      ) unless screener.valid?(:completion)
    end
  end

  # If there are some answers already present, we maintain these previous
  # answers (for example, it is possible to answer the postcode question
  # in the screener, and then do a bypass, maintaining the court data
  # returned from court tribunal finder).
  #
  def screener_answers_fixture(screener)
    {
      children_postcodes: 'MK9 2DT',
      parent: 'yes',
      over18: 'yes',
      written_agreement: 'no',
      email_consent: 'no',
      local_court: {
        "address" => {
          "address_lines" => ["351 Silbury Boulevard", "Witan Gate East"],
          "town" => "Central Milton Keynes",
          "postcode" => "MK9 2DT",
        },
        "name" => "Milton Keynes County Court and Family Court",
        "slug" => "milton-keynes-county-court-and-family-court",
        "email" => "family@miltonkeynes.countycourt.gsi.gov.uk",
      }
    }.merge(screener.attributes.symbolize_keys) do |_key, old_value, new_value|
      new_value || old_value
    end
  end
  # :nocov:
end
