class OnlineSubmissionJob < ApplicationJob
  queue_as :submissions

  def perform(c100_application)
    C100App::OnlineSubmission.new(c100_application).process
  end
end
