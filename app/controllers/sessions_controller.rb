class SessionsController < ApplicationController
  skip_before_action :ensure_session_validity, only: [:destroy]

  def ping
    head(:no_content)
  end

  def destroy
    # When redirecting to the survey, we want to logout the user. But when only taking the users to the home,
    # we don't want to log them out but instead only reset the current case in session.
    show_survey = params[:survey] == 'true'
    show_survey ? reset_session : reset_c100_application_session

    respond_to do |format|
      format.html { redirect_to show_survey ? Rails.configuration.surveys[:success] : root_path }
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
      screener.update(children_postcodes: 'MK9 2DT', local_court: local_court_fixture)
    end
  end

  def local_court_fixture
    {
      "address_lines" => ["351 Silbury Boulevard", "Witan Gate East"],
      "town" => "Central Milton Keynes",
      "postcode" => "MK9 2DT",
      "name" => "Milton Keynes County Court and Family Court",
      "slug" => "milton-keynes-county-court-and-family-court",
      "phone_number" => 388,
      "email" => "family@miltonkeynes.countycourt.gsi.gov.uk",
      "opening_times" =>
        [
          "Bailiff telephone service: For payments only Tel: 01865 264200 (option 1 then option 7)",
          "Court counter open: by prior appointment only",
          "Court building open: Monday to Friday 8:30am to 4pm",
          "Telephone Enquiries from: 9am to 5pm"
        ]
    }
  end
  # :nocov:
end
