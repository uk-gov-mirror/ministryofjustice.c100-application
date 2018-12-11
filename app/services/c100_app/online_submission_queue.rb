module C100App
  class OnlineSubmissionQueue
    attr_reader :c100_application

    def initialize(c100_application)
      @c100_application = c100_application
    end

    def process
      # Do not process again if we have a DB record, to avoid duplicating emails
      return if processed?

      initialize_audit!

      CourtDeliveryJob.perform_later(c100_application)
      ApplicantDeliveryJob.perform_later(c100_application) if receipt?
    end

    private

    def receipt?
      c100_application.receipt_email?
    end

    def processed?
      c100_application.email_submission.present?
    end

    def initialize_audit!
      c100_application.create_email_submission
    end
  end
end
