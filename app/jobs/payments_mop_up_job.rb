# There are 2 failure cases which affect the integration with GOV.UK Pay:
#
# - the user abandons their payment journey before completing it
# - the user completes their payment successfully, but their network connection
#   is interrupted before they return to our service
#
# In these failure cases, the user will never visit the `return_url`.
#
# Instead, we must use an automatic mop-up job as a background process which
# checks the outcome of incomplete payment journeys.
#
class PaymentsMopUpJob < ApplicationJob
  queue_as :default

  def self.run(date)
    C100Application.payment_in_progress
      .joins(:payment_intent)
      .where("payment_intents.state ->> 'finished' = 'false'")
      .where("payment_intents.created_at <= :date", date: date)
      .each do |c100_application|
        logger.info "Enqueuing payment status refresh for application #{c100_application.id}"
        perform_later(c100_application)
      end
  end

  def perform(c100_application)
    return unless C100App::OnlinePayments.retrieve_payment(
      c100_application.payment_intent
    ).success?

    c100_application.mark_as_completed!

    C100App::OnlineSubmissionQueue.new(
      c100_application
    ).process if c100_application.online_submission?
  end
end
