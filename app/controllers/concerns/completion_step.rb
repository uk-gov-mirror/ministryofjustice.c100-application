module CompletionStep
  extend ActiveSupport::Concern

  included do
    before_action :mark_completed
  end

  private

  def mark_completed
    # The step including this concern will mark the current application as `completed`,
    # meaning it can't be drafted (and don't appear anymore in drafts).
    current_c100_application.completed!
  end

  # TODO: I don't understand why these two different ways of retrieving the court
  # data? Can we just get everything with the first (or the second) one?

  def court_from_screener_answers
    Court.new.from_courtfinder_data!(
      current_c100_application.screener_answers.try(:local_court)
    )
  end

  def local_court
    Court.new(current_c100_application.screener_answers.try(:local_court))
  end
end
