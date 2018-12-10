class ApplicantDeliveryJob < ApplicationJob
  queue_as :applicant_receipts

  def perform(c100_application)
    C100App::OnlineSubmission.new(
      c100_application, recipient: :applicant
    ).process
  end
end
