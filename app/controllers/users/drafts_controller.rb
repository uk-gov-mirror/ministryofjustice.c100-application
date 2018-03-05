module Users
  class DraftsController < ApplicationController
    before_action :authenticate_user!

    def index
      @drafts = drafts.order(created_at: :asc)
    end

    def resume
      c100_application = draft_from_params
      session[:c100_application_id] = c100_application.id
      redirect_to c100_application.navigation_stack.last
    end

    def destroy
      draft_from_params.destroy
      redirect_to users_drafts_path
    end

    private

    def drafts
      current_user.drafts
    end

    def draft_from_params
      drafts.find_by(id: params[:id]) || (raise Errors::ApplicationNotFound)
    end
  end
end
