module C100App
  class OnlinePayments
    include Rails.application.routes.url_helpers

    attr_reader :c100_application

    def initialize(c100_application)
      @c100_application = c100_application
    end

    def payment_url
      create_payment.payment_url
    end

    private

    def create_payment
      PaymentsApi::Requests::CreateCardPayment.new(payload).call
    end

    # TODO: extract details to a better place/constants/config
    def payload
      {
        amount: 215_00,
        reference: c100_application.reference_code,               # TODO: maybe append GBS code?
        return_url: steps_completion_confirmation_url,            # TODO: identify returned users
        description: 'Court fee for lodging a C100 application',  # TODO: description TBD

        # Optional details
        email: c100_application.receipt_email,
      }
    end
  end
end
