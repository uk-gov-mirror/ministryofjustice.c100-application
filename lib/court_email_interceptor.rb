# This interceptor is only used in dev or test environments.
# Refer to `/initializers/court_email_interceptor.rb` for more information.
#
class CourtEmailInterceptor
  # Add here the delivery handlers allowed to bypass the interception.
  DELIVERY_WHITELIST = %w[
    NotifyMailer
    ReceiptMailer
    ReportsMailer
  ].freeze

  class << self
    def delivering_email(message)
      return if whitelisted?(message)
      intercept_email!(message)
    end

    private

    def whitelisted?(message)
      DELIVERY_WHITELIST.include?(message.delivery_handler.to_s)
    end

    def intercept_email!(message)
      message.subject = "#{message.subject} | (Original recipient: #{message.to.join(',')})"
      message.to = message.from
    end
  end
end
