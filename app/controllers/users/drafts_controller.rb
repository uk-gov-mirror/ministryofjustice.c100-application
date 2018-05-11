module Users
  class DraftsController < ApplicationController
    before_action :authenticate_user!

    def index
      @drafts = current_user.c100_applications.order(created_at: :asc)
    end

    def resume
      # Note: there is no need for `else` because `draft_from_params`
      # will raise an exception if no application was found
      #
      if completed_application_from_params
        set_session_and_redirect(
          completed_application_from_params,
          steps_completion_how_to_submit_path
        )
      elsif draft_from_params
        set_session_and_redirect(
          draft_from_params,
          check_your_answers_or_last_step # temporary feature-flagged journey
        )
      end
    end

    def destroy
      draft_from_params.destroy
      redirect_to users_drafts_path
    end

    private

    def completed_application_from_params
      @_c100_application ||= current_user.completed_applications.find_by(id: params[:id])
    end

    def draft_from_params
      @_c100_application ||= current_user.drafts.find_by(id: params[:id]) || (raise Errors::ApplicationNotFound)
    end

    def set_session_and_redirect(c100_application, path)
      session[:c100_application_id] = c100_application.id
      redirect_to path
    end

    def check_your_answers_or_last_step
      if helpers.dev_tools_enabled?
        resume_steps_application_check_your_answers_path
      else
        draft_from_params.navigation_stack.last
      end
    end
  end
end
