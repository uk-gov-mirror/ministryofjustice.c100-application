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
end
