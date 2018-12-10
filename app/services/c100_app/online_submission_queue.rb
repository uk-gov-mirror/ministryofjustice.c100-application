module C100App
  class OnlineSubmissionQueue
    attr_reader :c100_application

    def initialize(c100_application)
      @c100_application = c100_application
    end

    def process
      CourtDeliveryJob.perform_later(c100_application)
      ApplicantDeliveryJob.perform_later(c100_application) if receipt?
    end

    private

    def receipt?
      c100_application.receipt_email.present?
    end
  end
end
