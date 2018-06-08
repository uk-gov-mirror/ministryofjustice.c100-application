# The step including this concern will mark the application as `completed`,
# meaning it can't be drafted anymore, also can't be submitted again by mistake,
# and we save an audit record of this submission and the court it was sent to.
#
module CompletionStep
  extend ActiveSupport::Concern

  included do
    before_action :mark_completed, unless: :completed?
  end

  def show
    @court = current_c100_application.screener_answers_court
  end

  private

  def completed?
    current_c100_application.completed?
  end

  def mark_completed
    current_c100_application.completed!

    CompletedApplicationsAudit.log!(
      current_c100_application
    )
  end
end
