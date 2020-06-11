module C100App
  class OnlinePayments
    # Failure codes that indicate either the user do not want to proceed,
    # or the payments provider is having technical issues.
    NON_RETRYABLE_CODES = %w[
      P0030
      P0050
    ].freeze

    attr_reader :payment_intent
    delegate :c100_application, to: :payment_intent

    def initialize(payment_intent)
      @payment_intent = payment_intent
    end
    private_class_method :new

    class << self
      def create_payment(payment_intent)
        new(payment_intent).create_payment
      end

      def retrieve_payment(payment_intent)
        new(payment_intent).retrieve_payment
      end

      def non_retryable_state?(payment_intent)
        NON_RETRYABLE_CODES.include?(payment_intent.state['code'])
      end
    end

    def create_payment
      response = PaymentsApi::Requests::CreateCardPayment.new(
        details_payload
      ).call

      update_intent!(response)
      response
    end

    def retrieve_payment
      response = PaymentsApi::Requests::GetCardPayment.new(
        payment_id: payment_intent.payment_id
      ).call

      update_intent!(response)
      response
    end

    private

    def update_intent!(response)
      payment_intent.update(
        payment_id: response.payment_id,
        state: response.state,
      )
    end

    # TODO: hardcoded values to a better place, i.e. constants/config
    def details_payload
      {
        amount: 215_00,
        description: 'Court fee for lodging a C100 application',
        reference: c100_application.reference_code,

        # One-time return url
        return_url: payment_intent.return_url,

        # Optional details
        email: c100_application.receipt_email,
        metadata: {
          court_gbs_code: 'TBD',
          court_name: c100_application.screener_answers_court.name,
          court_email: c100_application.screener_answers_court.email,
        }
      }
    end
  end
end
