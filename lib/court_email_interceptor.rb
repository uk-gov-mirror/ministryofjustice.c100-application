# This interceptor is only used in dev or test environments.
# Refer to `/initializers/court_email_interceptor.rb` for more information.
#
class CourtEmailInterceptor
  # Add here the delivery handlers allowed to bypass the interception.
  DELIVERY_WHITELIST = [
    NotifyMailer,
    ReceiptMailer,
  ].freeze

  class << self
    def delivering_email(message)
      return if whitelisted?(message)
      intercept_email!(message)
    end

    private

    def whitelisted?(message)
      DELIVERY_WHITELIST.include?(message.delivery_handler)
    end

    def intercept_email!(message)
      # If the user chose to receive a confirmation receipt, we will use this
      # `reply-to` address as the new recipient of the intercepted email.
      # Otherwise we will just stop the delivery completely.
      #
      if message.reply_to.present?
        message.subject = "#{message.subject} | (Original recipient: #{message.to.join(',')})"
        message.to = message.reply_to
      else
        message.perform_deliveries = false
      end
    end
  end
end
