module C100App
  class OnlinePayments
    class UnknownPaymentStatus < StandardError; end

    STATUSES_ENUM_MAP = {
      created: %w[created],
      pending: %w[started submitted capturable],
      success: %w[success],
      failed:  %w[failed cancelled error],
    }.freeze

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
        status: choose_status(response.status),
      )
    end

    def choose_status(status)
      case status
      when *STATUSES_ENUM_MAP.fetch(:created)
        :created
      when *STATUSES_ENUM_MAP.fetch(:pending)
        :pending
      when *STATUSES_ENUM_MAP.fetch(:success)
        :success
      when *STATUSES_ENUM_MAP.fetch(:failed)
        :failed
      else
        raise UnknownPaymentStatus, status
      end
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
