class SendApplicationToCourtJob < ApplicationJob
  queue_as :submissions

  def perform(c100_application)
    C100App::SendApplicationToCourt.new(c100_application).process
  end
end
