module CompletionStep
  extend ActiveSupport::Concern

  included do
    before_action :mark_completed
  end

  def show
    @court = current_c100_application.screener_answers_court
  end

  private

  def mark_completed
    # The step including this concern will mark the current application as `completed`,
    # meaning it can't be drafted (and don't appear anymore in drafts).
    current_c100_application.completed!
  end
end
