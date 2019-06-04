class ApplicantDeliveryJob < ApplicationJob
  queue_as :applicant_receipts

  def perform(c100_application)
    C100App::ApplicantOnlineSubmission.new(c100_application).process
  ensure
    GC.start # force garbage collection
  end
end
