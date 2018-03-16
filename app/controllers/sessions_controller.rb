class SessionsController < ApplicationController
  def ping
    head(:no_content)
  end

  def destroy
    # When redirecting to the survey, we want to logout the user. But when only taking the users to the home,
    # we don't want to log them out but instead only reset the current case in session.
    show_survey = params[:survey] == 'true'
    show_survey ? reset_session : reset_c100_application_session

    respond_to do |format|
      format.html { redirect_to show_survey ? Rails.configuration.survey_link : root_path }
      format.json { render json: {} }
    end
  end

  # :nocov:
  def bypass_screener
    raise 'For development use only' unless Rails.env.development? || ENV['DEV_TOOLS_ENABLED']

    c100_application.update(status: 1)
    redirect_to edit_steps_miam_child_protection_cases_path
  end
  # :nocov:

  private

  # :nocov:
  def c100_application
    current_c100_application || C100Application.create.tap do |c100_application|
      session[:c100_application_id] = c100_application.id
    end
  end
  # :nocov:
end
