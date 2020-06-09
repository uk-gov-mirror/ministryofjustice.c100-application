class PaymentsController < ApplicationController
  before_action :check_intent_presence

  def validate
    payment_intent.revoke_nonce!

    redirect_to C100App::PaymentsFlowControl.new(
      current_c100_application
    ).next_url
  end

  private

  def payment_intent
    @_payment_intent ||= PaymentIntent.not_finished.find_by(
      id: params.require(:id), nonce: params.require(:nonce), c100_application: current_c100_application
    )
  end

  def check_intent_presence
    raise Errors::InvalidSession unless payment_intent
  end
end
