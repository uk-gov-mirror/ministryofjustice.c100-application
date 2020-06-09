module C100App
  class PaymentsFlowControl
    include Rails.application.routes.url_helpers

    attr_reader :c100_application

    def initialize(c100_application)
      @c100_application = c100_application
    end

    def payment_url
      return confirmation_url unless payments_enabled?

      if c100_application.online_payment?
        OnlinePayments.create_payment(payment_intent).payment_url
      else
        payment_intent.finish!(with_status: :offline_type)
        confirmation_url
      end
    end

    # Returning users after paying (or failing/cancelling)
    # TODO: create specific error pages for different scenarios
    #
    def next_url
      OnlinePayments.retrieve_payment(payment_intent)

      case payment_intent.status
      when 'success'
        payment_intent.finish!
        confirmation_url
      else
        unhandled_errors_path
      end
    end

    def confirmation_url
      if c100_application.online_submission?
        OnlineSubmissionQueue.new(c100_application).process
        steps_completion_confirmation_path
      else
        steps_completion_what_next_path
      end
    end

    private

    def payment_intent
      @_payment_intent ||= PaymentIntent.find_or_create_by!(
        c100_application: c100_application
      )
    end

    # TODO: For now, we only run the online payments code if some criteria is met,
    # to avoid genuine tests or demos on staging while still WIP.
    #
    def payments_enabled?
      c100_application.declaration_signee.eql?('John Doe')
    end
  end
end
